#!/usr/local/bin/lua

text = { }
text.defaultValue = { size = 14, content = "hello" }
text.mt = { }  -- 创建元表

function text.new( a )
    setmetatable( a, text.mt )
    return a
end

text.mt.__index = function( tb, key )
    return text.defaultValue[key]
end

local x = text.new{ content = "bye" }
print( x.size , x.content)   --> 14
print('------------------------------------')

--这一部分我们通过一个简单的例子介绍如何使用 metamethods。假定我们使用 table 来描述结合，使用函数来描述集合的并操作，交集操作，like 操作。我们在一个表内定义这些函数，然后使用构造函数创建一个集合：
Set = {}
Set.mt = {}   --将所有集合共享一个metatable
function Set.new(t)   --新建一个表
    local set = {}
    setmetatable(set, Set.mt)
    for _, l in ipairs(t) do
        set[l] = true
    end
    return set
end

function Set.union(a,b)   --并集
    local res = Set.new{}  --注意这里是大括号
    for i in pairs(a) do
        res[i] = true
    end
    for i in pairs(b) do
        res[i] = true
    end
    return res
end

function Set.intersection(a,b)   --交集
    local res = Set.new{}   --注意这里是大括号
    for i in pairs(a) do
        res[i] = b[i]
    end
    return res
end

function Set.tostring(set)  --打印函数输出结果的调用函数
    local s = "{"
    local sep = ""
    for i in pairs(set) do
        s = s..sep..i
        sep = ","
    end
    return s.."}"
end

function Set.print(set)   --打印函数输出结果
    print(Set.tostring(set))
end

--[[
Lua中定义的常用的Metamethod如下所示：
算术运算符的Metamethod：
__add（加运算）、__mul（乘）、__sub(减)、__div(除)、__unm(负)、__pow(幂)，__concat（定义连接行为）。

关系运算符的Metamethod：
__eq（等于）、__lt（小于）、__le（小于等于），其他的关系运算自动转换为这三个基本的运算。

库定义的Metamethod：
__tostring（tostring函数的行为）、__metatable（对表getmetatable和setmetatable的行为）。
]]

Set.mt.__add = Set.union
s1 = Set.new{1,2}
s2 = Set.new{3,4}
print(getmetatable(s1))
print(getmetatable(s2))
s3 = s1 + s2
Set.print(s3)

Set.mt.__mul = Set.intersection   --使用相乘运算符来定义集合的交集操作
Set.print((s1 + s2)*s1)

--如上所示，用表进行了集合的并集和交集操作。
--Lua 选择 metamethod 的原则：如果第一个参数存在带有 __add 域的 metatable，Lua 使用它作为 metamethod，和第二个参数无关；
--否则第二个参数存在带有 __add 域的 metatable，Lua 使用它作为 metamethod 否则报错。
print('------------------------------------')
--根据 __newindex 的这一个特性，可以用来跟踪一个 table 赋值更新的操作，如果是一个只读的 table ，可以通过 __newindex 来实现下面是代码 lua 中
--__newindex 的调用机制跟 __index 的调用机制是一样的，当访问 table 中一个不存在的 key，并对其赋值的时候，lua 解释器会查找 __newindex 元方法，如果存在，调用该方法，如果不存在，直接对原 table 索引进行赋值操作。
local t = {}
local prototype = {}
local mt = {
    __index = function(t, k)
        return prototype[k]
    end
,
    __newindex = function(t, k, v)
        print("attempt to update a table k-v")
        prototype[k] = v
    end
}

setmetatable(t, mt)
t[2] = "hello"
print(t[2])
--输出：
--attempt to update a table k-v
--hello
print('------------')
--根据 __newindex 的这一个特性，可以用来跟踪一个 table 赋值更新的操作，如果是一个只读的 table ，可以通过 __newindex 来实现下面是代码:
function readOnly(t)
    local proxy = {}  --定义一个空表，访问任何索引都是不存在的，所以会调用__index 和__newindex
    local mt = {
        __index = t, ---__index 可以是函数，也可以是table，是table的话，调用直接返回table的索引值
        __newindex = function(t,k,v)
            error("attempt to update a read-only table",2)
        end
    }
    setmetatable(proxy,mt)
    return proxy
end

days = readOnly{"Sunday","Monday","Tuesday","Wednessday","Thursday","Friday","Saturday"}
print(days[1])
--days[2] = "hello"  --这一行就非法访问了
--输出：
--Sunday
--: attempt to update a read-only table
print('------------------------------------')
--__newindex 有两个规则：
--1、如果 __newindex 是一个函数，则在给 table 中不存在的字段赋值时，会调用这个函数，并且赋值不成功。
--2、如果 __newindex 是一个 table，则在给 table 中不存在的字段赋值时，会直接给 __newindex的table 赋值。
print('------------------------------------')
--参考二楼的写法可以再加一个差集：
function Set.diff(a,b)
    local res = Set.new{}
    local unionRes = a + b
    local intersectionRes = a * b
    for i in pairs(unionRes)
    do
        if (intersectionRes[i]==nil)
        then
            res[i]=unionRes[i]
        end
    end
    return res
end
print('------------------------------------')
--参考楼上写法，给出另一种差集实现：
function Set.sub(a,b)
    local res = Set.new({})
    for k,v in pairs(a)
    do
        if(b[k] == nil)
        then
            res[k] = true
        end
    end
    return res
end
print('------------------------------------')