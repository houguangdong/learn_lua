#!/usr/local/bin/lua

--其他面向对象的概念
--封装
--封装通常通过将数据和方法封装在一个表中实现。我们可以通过控制表的访问权限来模拟封装，例如使用 metamethods 来限制外部访问。

-- 定义一个"类"（实际上是一个表）
Person = {}

-- 添加封装：隐藏属性
function Person:new(name, age)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.name = name
    obj.age = age
    return obj
end

function Person:setName(name)
    self.name = name  -- 提供方法来修改 name
end

function Person:getName()
    return self.name  -- 提供方法来获取 name
end

--通过这种方式，我们可以控制属性的访问，模拟封装。
print('------------------------------------')
--抽象
--抽象指的是简化复杂的事物，将不需要的细节隐藏。虽然 Lua 本身没有类的概念，但我们可以通过封装来达到抽象的目的。

-- 只暴露接口，不暴露实现细节
function Person:showInfo()
    print("Name: " .. self.name)
    print("Age: " .. self.age)
end