#!/usr/local/bin/lua

--3. debug 库常用小技巧组合示例
-- 模拟一个比较深的调用链
local function level3()
    error("这里故意抛错啦！")
end

local function level2()
    level3()
end

local function level1()
    level2()
end

-- 保护调用 + debug 信息
local function safe_call()
    local ok, err = xpcall(level1, function(err_msg)
        --debug.traceback 的正确签名（Lua 5.1 ~ 5.4 通用）
        --第一个参数（可选）：thread（协程），通常省略
        --第二个参数（可选）：message（错误消息字符串，通常是你想放在栈追踪最前面的那行）
        --第三个参数（可选）：level（从哪一层开始收集栈，默认为 1）
        local msg = debug.traceback(err_msg, 3) -- 从第3层开始（跳过 error_handler 本身）

        -- 额外附加一些上下文信息
        msg = msg .. "\n\n额外调试信息："
        msg = msg .. "\n当前局部变量 a = " .. tostring(_G.a or "nil")
        msg = msg .. "\n当前文件名  = " .. debug.getinfo(2, "S").short_src

        return msg
    end)

    if not ok then
        print("┌─────────────── 错误 ───────────────┐")
        print(err)
        print("└────────────────────────────────────┘")
    else
        print("一切正常")
    end
end

_G.a = 666   -- 模拟全局变量
safe_call()

----快速对比表
--函数,     返回值,                            错误处理函数,         常用来做,                        典型场景
--pcall,   "ok, 返回值... 或 ok, err_msg",     无,                 简单保护调用,                    调用可能出错的 API
--xpcall,  "ok, 返回值... 或 ok, err_msg",     有（自定义）,         需要完整调用栈、日志、美化,         框架、插件、后台任务
--assert,  不抛错返回第一个参数，抛错终止,         无,                 开发期断言,                      参数检查、逻辑前置条件
--error(), 主动抛错,                           —,                 业务逻辑错误,                     参数非法、状态不对


--总结推荐写法（生产环境常见模式）
local function try(fn, ...)
    local args = {...}
    return xpcall(function()
            return fn(table.unpack(args))
        end, function(err)
        -- 可以在这里接 logging 系统、Sentry、上报等
        local tb = debug.traceback(err, 3)
        print("ERROR:", tb)
        return nil, tb
    end)
end

-- 使用方式
local ok, res, trace = try(
    function(a,b)
        return a+b
    end,
    10,
    "20"
)
if not ok then
    -- 处理错误
end

--常见正确写法对比
--你想要的效果,                                  推荐写法,                                                说明
--只想要 traceback，不加自定义错误信息,             "debug.traceback(nil, 3) 或 debug.traceback(3)",        从第3层开始收集栈
--想要在 traceback 前面加一行自定义错误信息,         "debug.traceback(err_msg, 3)",                          ← 你的写法，其实是对的
--想要在 traceback 前面加一行 + 跳过更多层,         "debug.traceback(""错误: "" .. err_msg, 4)",             常见于再包一层 error handler 时
--最安全/最清晰的写法（推荐）,                      "debug.traceback(err_msg or ""error"", 3)",              防止 err_msg 是 nil 时行为奇怪
print("------------------------------------------------------------------------------------------------")
--典型的使用场景（xpcall 的 error handler）
local function error_handler(err)
    -- 常见的写法：把原始错误 + 完整的调用栈都记录下来
    local full_msg = debug.traceback(err, 2)    -- 2 就够了（跳过 error_handler 本身）
    -- 或
    -- local full_msg = debug.traceback("错误发生: " .. tostring(err), 2)

    -- 可以在这里记录日志、发警报等
    print(full_msg)
    return full_msg   -- 通常要 return 出去，让 xpcall 的第二个返回值拿到
end

local ok, result = xpcall(dangerous_function, error_handler, arg1, arg2)
--debug.traceback(3)          -- 只追踪栈，不加额外消息
-- 或
--debug.traceback(err, 3)     -- err 是错误对象，3 是 level
--所以最保险的做法是显式写出 nil 或明确意图：
-- 推荐三种清晰写法
local msg1 = debug.traceback(err_msg, 3)              -- 你的写法，ok
local msg2 = debug.traceback(tostring(err_msg or ""), 3)
local msg3 = debug.traceback("错误: " .. tostring(err_msg), 2)
print(ok, result, msg1, msg2, msg3)
print("------------------------------------------------------------------------------------------------")