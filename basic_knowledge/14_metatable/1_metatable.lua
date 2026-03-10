#!/usr/local/bin/lua

--Lua 元表(Metatable)
--在 Lua table 中我们可以访问对应的 key 来得到 value 值，但是却无法对两个 table 进行操作(比如相加)。
--因此 Lua 提供了元表(Metatable)，允许我们改变 table 的行为，每个行为关联了对应的元方法。
--
--例如，使用元表我们可以定义 Lua 如何计算两个 table 的相加操作 a+b。
--当 Lua 试图对两个表进行相加时，先检查两者之一是否有元表，之后检查是否有一个叫 __add 的字段，若找到，则调用对应的值。 __add等即时字段，其对应的值（往往是一个函数或是 table）就是"元方法"。
--有两个很重要的函数来处理元表：
--    setmetatable(table,metatable): 对指定 table 设置元表(metatable)，如果元表(metatable)中存在 __metatable 键值，setmetatable 会失败。
--    getmetatable(table): 返回对象的元表(metatable)。
--
--以下实例演示了如何对指定的表设置元表：
mytable = {}                          -- 普通表
mymetatable = {}                      -- 元表
setmetatable(mytable, mymetatable)    -- 把 mymetatable 设为 mytable 的元表

--以上代码也可以直接写成一行：
mytable = setmetatable({},{})

--以下为返回对象元表：
getmetatable(mytable)                 -- 这会返回 mymetatable
print('------------------------------------')
--模式	    描述
--__add	    对应的运算符 '+'.
--__sub	    对应的运算符 '-'.
--__mul	    对应的运算符 '*'.
--__div	    对应的运算符 '/'.
--__mod	    对应的运算符 '%'.
--__unm	    对应的运算符 '-'.
--__concat	对应的运算符 '..'.
--__eq	    对应的运算符 '=='.
--__lt	    对应的运算符 '<'.
--__le	    对应的运算符 '<='.
print('------------------------------------')