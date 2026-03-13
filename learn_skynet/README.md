###
3rd: 调用第三方的c语言源码
    compat-mingw: 兼容mingw的源码
    jemalloc: jemalloc 是一个通用的 malloc(3) 实现，它强调避免内存碎片和可扩展的并发支持。
    lpeg: 解析 Lua 表达式语法
    lua: 定义的lua使用的c方法   这是 Lua 5.5 的一个修改版本 这是 Lua 团队维护的 Lua 开发代码仓库。它包含了所有提交的完整历史记录，但镜像更新并不定期。会根据(.h | .c)生成-->(.o)
    lua-md5: c语言的md5   MD5-Lua加密库

cservice: 编译生成的.so的服务，
    gate.so     --> service-src中的源码
    harbor.so   --> service-src中的源码
    logger.so   --> service-src中的源码
    snlua.so    --> service-src中的源码

examples: 各种lua使用的例子
    login:  登录服务
        client.lua
        gated.lua
        logind.lua
        main.lua
        msgagent.lua
    各种其他的服务例子

luaclib: 生成编译的框架使用的clib库文件
    bson.so     --> lualib-src中源码   lualib-src/lua-bson.c
    client.so   --> lualib-src中源码   lualib-src/lua-clientsocket.c lualib-src/lua-crypt.c lualib-src/lsha1.c
    lpeg.so     --> 3rd中的源码         3rd/lpeg/lpcap.c 3rd/lpeg/lpcode.c 3rd/lpeg/lpprint.c 3rd/lpeg/lptree.c 3rd/lpeg/lpvm.c 3rd/lpeg/lpcset.c
    md5.so      --> 3rd中的源码         3rd/lua-md5/md5.c 3rd/lua-md5/md5lib.c 3rd/lua-md5/compat-5.2.c
    skynet.so   --> skynet-src中的源码  由一堆c文件共同编译生成的
    sproto.so   --> lualib-src中源码   lualib-src/sproto/sproto.c lualib-src/sproto/lsproto.c | luaclib

lualib: 封装去调用底层luaclib生成的.so文件的各种方法
    compat10文件夹: 兼容10服务
    http文件夹: 封装http服务
    skynet文件夹: 封装框架提供的服务
    snax文件夹: 其他的服务
    loader.lua: 加载封装
    md5.lua: md5封装
    skynet.lua: 框架的封装
    sproto.lua: 协议的封装
    sprotoloader.lua: 加载协议文件
    sprotoparser.lua: 解析协议文件

lualib-src: 
    用c语言开发的各种lualib库的源码
    lua-skynet.c    服务的c文件
    
service: 封装去调用底层cservice生成的.so文件的各种方法
    bootstrap.lua: 引导程序封装
    cdummy.lua: 
    clusteragent.lua: 集群的代理
    clusterd.lua: 集群的封装
    clusterproxy.lua: 代理
    clustersender.lua: 发送
    cmaster.lua:
    cmemory.lua: 内存
    console.lua: 控制台
    cslave.lua: 从集群
    datacenterd.lua: 数据中心
    dbg.lua:
    debug_agent.lua: 调试代理
    debug_console.lua: 调试控制台
    gate.lua: 网关
    laucher.lua: 启动器
    multicastd.lua:
    service_cell.lua: 服务基础
    service_mgr.lua: 服务管理者
    service_provider.lua: 服务提供者
    sharedatad.lua: 分享数据
    snaxd.lua: 
    
service-src:                  用c语言开发的各种服务的源码
    databuffer.h              数据缓冲头文件
    hashid.h                  hashid头文件
    service_gate.c            网关服务
    service_harbor.c          harbor服务
    service_logger.c          日志服务
    service_snlua.c           snlua服务

skynet-src:                    
    用c语言开发的skynet框架服务的源码
    
test:                         各种使用lua的测试代码
    
#-----------------------------------------------------------------------------------------------------------------------
service(.lua)服务 --> cservice(.so) --> service-src(.h | .c)
lualib(.lua)各种lua的库方法 --> luaclib(.so) --> lualib-src(.h | .c | sproto协议)

