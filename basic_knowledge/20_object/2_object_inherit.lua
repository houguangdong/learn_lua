#!/usr/local/bin/lua

--Lua 继承
--继承是指一个对象直接使用另一对象的属性和方法，可用于扩展基础类的属性和方法。
--Lua 中的继承通过设置子类的元表来实现。
--我们可以创建一个新表，并将其元表设置为父类。
--以下实例 Square 类将继承 Rectangle 类的属性和方法，并在其基础上做出改动。

-- 定义矩形类
Rectangle = { area = 0, length = 0, breadth = 0}

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

-- 定义正方形类，继承自矩形类
Square = Rectangle:new()      -- Square 继承 Rectangle 类

-- 重写构造函数（正方形的边长相等）
function Square:new(o, side)
    o = o or {}  -- 如果未传入对象，创建一个新的空表
    setmetatable(o, self)  -- 设置元表，使其继承 Rectangle 的方法
    self.__index = self  -- 确保在访问时能找到方法和属性
    o.length = side or 0  -- 设置边长
    o.breadth = side or 0  -- 正方形的宽度和长度相等
    o.area = o.length * o.breadth  -- 计算面积
    return o
end

-- 运行实例：
local rect = Rectangle:new(nil, 5, 10)   -- 创建一个长为 5，宽为 10 的矩形
rect:printArea()     -- 输出 "矩形面积为 50"

local square = Square:new(nil, 4)  -- 创建一个边长为 4 的正方形
square:printArea()  -- 输出 "矩形面积为 16"

--Rectangle 类：依然是矩形的基本类，拥有 length、breadth 和 area 属性，以及计算和打印面积的方法。
--Square 类继承自 Rectangle：Square 类通过 Rectangle:new() 来继承 Rectangle 类的方法和属性。由于正方形的长度和宽度相等，
--我们在 Square:new 方法中重写了构造函数，将 length 和 breadth 设置为相同的值（即 side）。
--重写构造函数：Square:new(o, side) 方法创建正方形对象时，使用传入的边长 side 初始化 length 和 breadth 属性，并计算面积。
--运行结果：
--矩形面积为  50
--矩形面积为  16



print('------------------------------------')
--完整实例
-- Meta class
Shape = {area = 0}

-- 基础类方法 new
function Shape:new( o, side )
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    side = side or 0
    self.area = side * side
    return o
end

-- 基础类方法 printArea
function Shape:printArea( ... )
    print("面积为", self.area)
end

-- 创建对象
myshape = Shape:new(nil, 10)
myshape:printArea()
print('------------------------------------')
-- Lua 继承
-- Derived class method new. 派生类方法 new
Square = Shape:new()
function Square:new( o, side )
    o = o or Shape:new(o, side)
    setmetatable(o, self)
    self.__index = self
    return o
end

-- 完整实例
-- 以下实例我们继承了一个简单的类，来扩展派生类的方法，派生类中保留了继承类的成员变量和方法：
-- 派生类方法 printArea
function Square:printArea( ... )
    print("正方形面积为", self.area)
end

-- 创建对象
-- 接下来的实例，Square 对象继承了 Shape 类:
mysquare = Square:new(nil, 10)
mysquare:printArea()

Rectangle = Square:new()
-- 派生类方法 new
function Rectangle:new( o, length, breadth)
    o = o or Shape:new(o)
    setmetatable(o, self)
    self.__index = self
    self.area = length * breadth
    return o
end

-- 派生类方法 printArea
function Rectangle:printArea( ... )
    print("矩形面积为", self.area)
end

-- 创建对象
myrectangle = Rectangle:new(nil, 10, 20)
myrectangle:printArea()
print('------------------------------------')

-- 函数重写
-- Lua 中我们可以重写基础类的函数，在派生类中定义自己的实现方式：
function Square:printArea( ... )
    print("正方形面积 ", self.area)
end