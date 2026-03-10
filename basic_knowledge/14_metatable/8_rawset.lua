#!/usr/local/bin/lua

--rawset 是 Lua 标准库里的一个内置函数，全名叫 raw set（原始设置）。
--它的作用非常简单粗暴：
--Luarawset(table, key, value)
--
--直接在 table 这个表里，把 key 对应的值设成 value
--完全绕过（忽略）任何元表（metatable）里的 __newindex 元方法
--不触发任何 metamethod，也不做任何额外检查
--
--普通赋值 vs rawset 的对比
--普通写法：
--t[key] = value      -- 如果 t 有 __newindex 元方法，就会调用它，而不是直接赋值
--用 rawset：
--rawset(t, key, value)   -- 强制直接写进 t 的原始存储，不管有没有元表、__newindex 是什么

--最常见的几种使用场景（为什么需要它）
--防止无限递归 / 栈溢出（最经典用法）
--当你在 __newindex 元方法里想真正修改表本身时，必须用 rawset：
local mt = {}
mt.__newindex = function(t, k, v)
    print("有人试图设置 " .. tostring(k) .. " = " .. tostring(v))
    -- 如果这里写 t[k] = v，就会再次触发 __newindex → 死循环 → stack overflow
    rawset(t, k, v) -- 正确做法：直接原始赋值
end

local t = {}
setmetatable(t, mt)

t["11"] = 11
t.abc = 123   -- 会打印日志，然后真正存进去
print(t['11'], t.abc)

--1 实现“只读表”或“严格控制写入”
--你可以让普通赋值失败或记录日志，但内部还是要能写入某些值，就用 rawset。
--2 在元表操作中安全设置值
--比如在 __index / __newindex 里需要修改原表、代理表、缓存表等。
--3 性能敏感场景（少数）
--绕过 metamethod 检查，微小提速（但通常不值得为了这点性能专门用 rawset）。
--
--对应的一组函数（raw 家族）
--函数,                 作用,                         是否绕过 metamethod
--"rawget(t, k)",      原始读取 t[k],                 是（忽略 __index）
--"rawset(t, k, v)",   原始设置 t[k] = v,             是（忽略 __newindex）
--"rawequal(a, b)",    原始比较 a == b（不调用 __eq）,  是
--
--总结一句话
--rawset 就是“不管三七二十一，直接往表里塞值，不走元表那一套”的强制赋值函数。
--最典型的使用场景就是在 __newindex 元方法内部，用它来真正完成赋值，避免自己把自己递归死。
--如果你在写 metatable 相关的代码（代理、只读表、OO 实现、缓存等），几乎一定会用到 rawset/rawget。普通业务代码基本用不到。