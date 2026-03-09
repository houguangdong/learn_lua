#!/usr/local/bin/lua

--table.unpack 是 Lua 中用于将表格（table，通常是数组部分）展开成多个独立值的函数。
--它最常见的用途是将一个表格的内容作为多个参数传递给函数，或者将表格元素赋值给多个变量。

--完整签名（Lua 5.2+ / 5.3 / 5.4）
--Luatable.unpack(list [, i [, j]])
--list：要展开的表格（通常是连续整数键的数组部分）
--i：起始索引（默认 1）
--j：结束索引（默认 #list）

local t = {10, 20, 30, 40}

-- 展开成多个返回值
print(table.unpack(t))

-- 赋值给变量（多余的值会被丢弃）
local a, b = table.unpack(t)    --> a = 10, b = 20

-- 作为函数参数（最经典用法）
local function sum(x, y, z)
    return x + y + z
end

print(sum(table.unpack({1, 2, 3})))   --> 6

print(table.unpack(t, 2, 4))     --> 20  30  40
print(table.unpack(t, 3))        --> 30  40  50