#!/usr/local/bin/lua

--Lua 面向对象
--面向对象编程（Object Oriented Programming，OOP）是一种非常流行的计算机编程架构，通过创建和操作对象来设计应用程序。
--以下几种编程语言都支持面向对象编程：
--    C++
--    Java
--    Objective-C
--    Smalltalk
--    C#
--    Ruby
--Lua 是一种轻量级的脚本语言，虽然它不像 Java 或 C++ 那样内置强大的面向对象（OO）特性，但它非常灵活，可以通过一些技巧实现面向对象编程。
--面向对象特征
--    封装：将数据和方法捆绑在一起，隐藏实现细节，只暴露必要的接口，提高安全性和可维护性。
--    继承：通过派生新类复用和扩展现有代码，减少重复编码，提高开发效率和可扩展性。
--    多态：同一操作作用于不同对象时表现不同，支持统一接口调用，增强灵活性和扩展性。
--    抽象：简化复杂问题，定义核心类和接口，隐藏不必要的细节，便于管理复杂性。
--
--Lua 中面向对象
--我们知道，对象由属性和方法组成。
--Lua 中的类可以通过 table + function 模拟出来。
--至于继承，可以通过 metetable 模拟出来（不推荐用，只模拟最基本的对象大部分实现够用了）。
--在 Lua 中，最基本的结构是 table，我们可以使用表（table）来创建对象。
--ClassName = {}  -- 创建一个表作为类
--通过 new 方法（或其他名称）创建对象，并初始化对象的属性。
--function ClassName:new(...)
--    local obj = {}  -- 创建一个新的空表作为对象
--    setmetatable(obj, self)  -- 设置元表，使对象继承类的方法
--    self.__index = self  -- 设置索引元方法
--    -- 初始化对象的属性
--    obj:init(...)  -- 可选：调用初始化函数
--    return obj
--end

--表（table）是 Lua 中最基本的复合数据类型，可以用来表示对象的属性。
--Lua 中的 function 可以用来表示方法：
--function ClassName:sayHello()
--    print("Hello, my name is " .. self.name)
--end

--使用 new 方法来创建对象，并通过对象调用类的方法。
--local obj = ClassName:new("Alice")  -- 创建对象
--obj:sayHello()  -- 调用对象的方法
--在 Lua 中，表（table）可以视为对象的一种变体。和对象一样，表具有状态（成员变量），并且可以代表独立的实体。
--表不仅具有数据成员，还可以包含与对象方法类似的成员函数：
print("---------------------------------------")
-- 定义 Person 类
Person = {name = "", age = 0}

-- Person 的构造函数
function Person:new(name, age)
    local obj = {}  -- 创建一个新的表作为对象
    setmetatable(obj, self)  -- 设置元表，使其成为 Person 的实例
    self.__index = self  -- 设置索引元方法，指向 Person
    obj.name = name
    obj.age = age
    return obj
end

-- 添加方法：打印个人信息
function Person:introduce()
    print("My name is " .. self.name .. " and I am " .. self.age .. " years old.")
end

--代码说明:
--    Person 是一个表，它有两个属性：name 和 age，这两个属性是类的默认属性。
--    Person:new(name, age) 是一个构造函数，用来创建新的 Person 对象。
--    local obj = {} 创建一个新的表作为对象，setmetatable(obj, self) 设置元表，使得该表成为 Person 类的实例。
--    self.__index = self 设置索引元方法，使得 obj 可以访问 Person 类的属性和方法。
--    introduce 是 Person 类的方法，打印该 Person 对象的名字和年龄。
--
--调用方法:
-- 创建一个 Person 对象
local person1 = Person:new("Alice", 30)

-- 调用对象的方法
person1:introduce()  -- 输出 "My name is Alice and I am 30 years old."
print("---------------------------------------")
Account = {balance = 0}

function Account.withdraw(v)
    Account.balance = Account.balance - v
end

print(Account.withdraw(100.00))
print("---------------------------------------")
-- 一个简单实例
--以下简单的类包含了三个属性： area, length 和 breadth，printArea方法用于打印计算结果：
-- Meta class
-- 定义矩形类
Rectangle = {area = 0, length = 0, breadth = 0}

-- 派生类的方法 new
-- 创建矩形对象的构造函数
function Rectangle:new(o, length, breadth)
    o = o or {} -- 如果未传入对象，创建一个新的空表
    setmetatable(o, self) -- 设置元表，使其继承 Rectangle 的方法
    self.__index = self -- 确保在访问时能找到方法和属性
    o.length = length or 0 -- 设置长度，默认为 0
    o.breadth = breadth or 0 -- 设置宽度，默认为 0
    o.area = o.length * o.breadth -- 计算面积
    return o
end

-- 派生类的方法 printArea
-- 打印矩形的面积
function Rectangle:printArea( ... )
    print("矩形面积为", self.area)
end

--创建对象
--创建对象是为类的实例分配内存的过程，每个类都有属于自己的内存并共享公共数据：
r = Rectangle:new(nil, 10, 20)
--访问属性
--我们可以使用点号 .来访问类的属性：
print(r.length)
--访问成员函数
--我们可以使用冒号 : 来访问类的成员函数：
print(r:printArea())
--内存在对象初始化时分配。
print('------------------------------------')
--完整实例
--以下我们演示了 Lua 面向对象的完整实例：
-- 定义矩形类
Rectangle = {area = 0, length = 0, breadth = 0}

-- 创建矩形对象的构造函数
function Rectangle:new(o, length, breadth)
    o = o or {}  -- 如果未传入对象，创建一个新的空表
    setmetatable(o, self)  -- 设置元表，使其继承 Rectangle 的方法
    self.__index = self  -- 确保在访问时能找到方法和属性
    o.length = length or 0  -- 设置长度，默认为 0
    o.breadth = breadth or 0  -- 设置宽度，默认为 0
    o.area = o.length * o.breadth  -- 计算面积
    return o
end

-- 打印矩形的面积
function Rectangle:printArea()
    print("矩形面积为 ", self.area)
end

-- 运行实例：
local rect1 = Rectangle:new(nil, 5, 10)  -- 创建一个长为 5，宽为 10 的矩形
rect1:printArea()  -- 输出 "矩形面积为 50"

local rect2 = Rectangle:new(nil, 7, 3)  -- 创建一个长为 7，宽为 3 的矩形
rect2:printArea()  -- 输出 "矩形面积为 21"

--执行以上程序，输出结果为：
--矩形面积为      50
--矩形面积为      21