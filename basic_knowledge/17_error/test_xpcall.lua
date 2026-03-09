#!/usr/local/bin/lua

--2. xpcall + 自定义错误处理函数（能拿到调用栈）
local function error_handler(err)
    -- 可以在这里记录日志、发警报、格式化错误等
    return debug.traceback("【自定义错误】" .. err, 2)
end

local function risky()
    local t = {}
    print(t[1].name)          -- 会出错：尝试索引 nil 值
end

-- xpcall 的第二个参数是错误处理器
local success, result = xpcall(risky, error_handler)

if not success then
    print("捕获到错误：")
    print(result)   -- 会带上完整的 traceback
end

--捕获到错误：
--【自定义错误】basic_knowledge/17_error/test_xpcall.lua:11: attempt to index a nil value (field 'integer index')
--stack traceback:
--    basic_knowledge/17_error/test_xpcall.lua:11: in function <basic_knowledge/17_error/test_xpcall.lua:9>
--    [C]: in function 'xpcall'
--    basic_knowledge/17_error/test_xpcall.lua:15: in main chunk
--    [C]: in ?