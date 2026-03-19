local c = "skynet.core" # c指的是c语言生成的so库文件中的函数
这个core是通过lualib-src下面的lua-skynet.c编译生成的skynet.so,然后lua去调用这个so文件。

lualib-src下面的lua-skynet.c封装了各种方法

LUAMOD_API int
luaopen_skynet_core(lua_State *L) {
  ...
}

这个函数是 Skynet 框架最核心的 C → Lua 桥接函数，它的名字叫：
Cluaopen_skynet_core
这是 Lua 模块的入口函数（Lua C API 标准写法）。当你在 Lua 中执行 local skynet = require "skynet.core" 时，Lua 虚拟机最终会调用这个函数。
下面逐段详细解释：
1. 函数签名
CLUAMOD_API int luaopen_skynet_core(lua_State *L)

LUAMOD_API：宏，通常展开为 extern "C" __declspec(dllexport) 或类似，用于导出符号。
返回值是 int，表示这个模块往 Lua 栈上推入了几个值（这里返回 1，表示返回一个 table）。
参数 L 是当前的 Lua 状态机。


2. 注册第一组 API（需要 skynet_context 的函数）
CluaL_Reg l[] = {
    { "send" , lsend },
    { "genid", lgenid },
    { "redirect", lredirect },
    { "command" , lcommand },
    { "intcommand", lintcommand },
    { "addresscommand", laddresscommand },
    { "error", lerror },
    { "harbor", lharbor },
    { "callback", lcallback },
    { "trace", ltrace },
    { NULL, NULL },
};
这一组函数都是和当前服务（skynet_context）强关联的 C 函数，例如：

skynet.send()、skynet.genid()、skynet.redirect() 等
这些函数在 C 层实现时，通常需要从 Lua upvalue 或 registry 中拿到当前服务的 struct skynet_context *ctx


3. 注册第二组 API（不需要 skynet_context 的通用函数）
CluaL_Reg l2[] = {
    { "tostring", ltostring },
    { "pack",     luaseri_pack },
    { "unpack",   luaseri_unpack },
    { "packstring", lpackstring },
    { "trash" ,   ltrash },
    { "now",      lnow },
    { "hpc",      lhpc },
    { NULL, NULL },
};
这一组是纯工具函数，不依赖具体服务上下文：

skynet.tostring()：把 skynet 内部消息格式转成可读字符串
skynet.pack() / skynet.unpack()：Skynet 自己的序列化（比 Lua 原生更快）
skynet.now()：返回当前帧时间（毫秒）
skynet.hpc()：高精度时钟（微秒或纳秒级）


4. 创建模块 table 并预分配空间
Clua_createtable(L, 0, sizeof(l)/sizeof(l[0]) + sizeof(l2)/sizeof(l2[0]) -2);

创建一个新的 Lua table，作为 skynet.core 模块的返回值。
第二个参数是数组大小（0），第三个参数是 hash 部分预分配槽位。
-2 是因为两个数组都以 {NULL, NULL} 结尾，要减掉这两个。


5. 获取当前服务的上下文（关键！）
Clua_getfield(L, LUA_REGISTRYINDEX, "skynet_context");
struct skynet_context *ctx = lua_touserdata(L,-1);
if (ctx == NULL) {
    return luaL_error(L, "Init skynet context first");
}
这是 Skynet 非常重要的一步：

Skynet 在启动每个服务时，会把当前服务的 skynet_context 指针以 light userdata 的形式存到 Lua registry 里，key 是 "skynet_context"。
这里把它取出来。
如果取不到，说明这个模块没有在正确的 Skynet 服务环境中加载，直接报错。


6. 注册两组函数（最核心的部分）
CluaL_setfuncs(L, l,  1);   // 第3个参数 = 1，表示把 ctx 作为 upvalue 传给这些函数
luaL_setfuncs(L, l2, 0);   // 第3个参数 = 0，不带 upvalue

luaL_setfuncs 是 Lua 5.2+ 提供的便捷函数。
关键区别：
第一组 l 中的函数（send、command 等），每个函数的 C 实现里都可以通过 lua_upvalueindex(1) 拿到 ctx。
第二组 l2 中的函数不需要上下文，所以不带 upvalue。



7. 返回模块 table
Creturn 1;
把刚才创建的 table 返回给 Lua，这样 require "skynet.core" 就得到了一个包含所有 API 的 table。

总结：这个函数的作用
luaopen_skynet_core 是 Skynet C 模块的初始化入口，它完成了以下工作：

创建 skynet.core 这个 Lua module table。
把两组 C 函数（带上下文的 + 不带上下文的）注册到 table 中。
把当前服务的 skynet_context 指针作为 upvalue 绑定到需要它的函数上。
进行必要的安全检查。


在 Lua 中对应的调用关系
Lualocal core = require "skynet.core"

core.send(...)          -- 来自 l[] 数组，带 ctx upvalue
core.pack(...)          -- 来自 l2[] 数组，不带 ctx
core.now()