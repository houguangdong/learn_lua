#!/usr/local/bin/lua

--下面给你几个 Lua 中常用的 错误处理 + 调试 实用例子，涵盖 pcall、xpcall 和 debug 库的一些常见用法。
--1. 最常见的 pcall 用法（保护调用）
local function divide(a, b)
    if b == 0 then
        error("除数不能为 0")   -- 主动抛出错误
    end
    return a / b      -- 这里可能抛出除0错误
end

-- 普通调用（会直接报错终止）
-- print(divide(10, 0))   --> 会崩溃

-- 用 pcall 保护
local ok, result = pcall(divide, 10, 0) --在标准的 Lua（5.1 及以上版本）中，浮点数除以 0 不会抛出错误，而是按照 IEEE 754 浮点标准返回 inf（正无穷大）。

if ok then
    if result == math.huge or result == -math.huge then
        print("除以了 0，结果是无穷大:", result)
    else
        print("正常结果:", result)
    end
else
    print("出错了:", result)          -- result 此时是错误信息（字符串）
end
print("------------------------------------------------------------------------------------------------")
print(10 / 0)     --> inf
print(-10 / 0)    --> -inf
print(0 / 0)      --> nan   （不是 a number）
print("------------------------------------------------------------------------------------------------")
--只对整数除法强制报错
--print(10 // 0)   --> 这里才会真的抛出错误：attempt to divide by zero
--因为 // 是地板除（integer division），Lua 故意让它抛错，而 / 是浮点除，允许 inf。
--总结：
--你的代码没有错，行为完全符合 Lua 的设计。
--想让除 0 变成“错误” → 自己加 if b == 0 then error(...) 最直接。