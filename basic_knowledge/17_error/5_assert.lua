#!/usr/local/bin/lua


--Lua 中的 assert() 是最常用的防御性编程工具之一，主要用于“断言某个条件必须为真”，否则直接抛出错误（终止程序或抛出异常）。
--基本格式
--assert(条件 [, "出错时的自定义错误消息"])
--
--第一个参数：必须是真值（非 nil 且非 false）
--第二个参数（可选）：出错时显示的消息，强烈推荐写上，否则只显示 "assertion failed!"
--
--常用写法速查（带真实场景）
-- 1. 最简单用法
assert(age >= 18, "必须年满18岁才能进入")

-- 2. 检查函数返回值（最常见场景）
local file = io.open("config.json", "r")
assert(file, "无法打开配置文件 config.json")

-- 3. 防止除以0
assert(b ~= 0, "除数不能为0")
return a / b

-- 4. 检查 table 是否存在某个关键 key
--assert(t.version, "缺少 version 字段，数据格式错误")
--assert(type(t.version) == "string", "version 必须是字符串")

-- 5. 与 next 结合：判断 table 是否为空（经典写法）
--assert(next(tbl) ~= nil, "配置表不能为空")

-- 6. 配合 pcall 使用（想捕获错误而不是直接崩溃）
--local ok, err = pcall(function()
--    assert(condition, "出错了")
--end)
--if not ok then
--    print("捕获到断言失败：", err)
--end

--assert 的行为特点（重要）
--情况,                             结果,                                      是否继续执行
--条件为 true / 非nil非false,        正常返回第一个参数的值,                        继续
--条件为 false 或 nil,               抛出错误（error()）,                         立即终止
--不传第二个参数,                     "错误消息只有 ""assertion failed!""",        —
--在 LuaJIT / Lua 5.1+,             性能几乎无损（debug 模式下才稍慢）,             —
--
--实际开发中的几种风格对比
-- 风格A：严格（生产环境常见）
local data = load_data()
assert(data, "数据加载失败")
assert(#data > 0, "数据为空")

-- 风格B：带类型检查（库/模块作者常用）
assert(type(opts) == "table", "opts 必须是 table")
assert(opts.timeout, "缺少 timeout 配置")

-- 风格C：只在开发/测试阶段用（上线可关）
-- 很多项目会这样写：
local function CHECK(cond, msg)
    if not cond then
        if _G.DEBUG then
            assert(false, msg or "CHECK 失败")
        else
            error(msg or "CHECK 失败", 2)
        end
    end
end

--小技巧
--想只在调试时生效？可以用全局标志：
local ENABLE_ASSERT = _G.DEBUG or false
local function assert_dev(...)
    if ENABLE_ASSERT then
        assert(...)
    end
end

--想让 assert 返回值继续使用？
local x = assert(tonumber(str), "不是有效数字：" .. str)
-- x 就是转换后的数字

