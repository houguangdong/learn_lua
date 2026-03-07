#!/usr/local/bin/lua

--函数重写
--在 Lua 中，函数重写（也称为方法重写）指的是在继承过程中，子类对父类中已有方法的重新定义或替换。
--子类可以根据需要修改或扩展父类的方法行为。
--以上实例中 Square 类重写了 Rectangle 类的构造函数，从而改变了对象的初始化方式，特别是将矩形的 length 和 breadth 设为相同的值，因为正方形的特性是边长相等。
--接下来我们通过一个 Animal 类和一个继承自它的 Dog 类，展示如何重写方法。

-- 定义动物类（Animal）
Animal = {name = "Unknown"}

-- Animal 类的构造函数
function Animal:new(o, name)
    o = o or {}  -- 如果没有传入对象，则创建一个新的空表
    setmetatable(o, self)  -- 设置元表，使其继承 Animal 的方法
    self.__index = self  -- 让对象可以访问 Animal 的方法
    o.name = name or "Unknown"  -- 设置名称，默认为 "Unknown"
    return o
end

-- Animal 类的方法：叫声
function Animal:speak()
    print(self.name .. " makes a sound.")
end

-- 定义狗类（Dog），继承自 Animal
Dog = Animal:new() -- Dog 继承 Animal 类

-- 重写狗类的构造函数
function Dog:new(o, name, breed)
    o = o or {}  -- 如果没有传入对象，则创建一个新的空表
    setmetatable(o, self)  -- 设置元表，使其继承 Dog 和 Animal 的方法
    self.__index = self  -- 让对象可以访问 Dog 的方法
    o.name = name or "Unknown"
    o.breed = breed or "Unknown"
    return o
end

-- 重写狗类的叫声方法（重写 Animal 的 speak 方法）
function Dog:speak()
    print(self.name .. " barks.")
end

-- 创建 Animal 对象
local animal = Animal:new(nil, "Generic Animal")
animal:speak()  -- 输出 "Generic Animal makes a sound."

-- 创建 Dog 对象
local dog = Dog:new(nil, "Buddy", "Golden Retriever")
dog:speak()  -- 输出 "Buddy barks."

--Animal 类：定义了一个基础类 Animal，具有 name 属性和 speak 方法。speak 方法是一个默认的实现，输出"某个动物发出声音"。
--Dog 类继承 Animal：Dog 类继承自 Animal，并通过 Dog:new() 方法创建自己的实例。
--重写 speak 方法：在 Dog 类中，重写了 speak 方法，将其行为从父类的"发出声音"改为"狗狗叫"。这就是方法重写的体现，子类（Dog）改变了父类（Animal）方法的行为。
--
--运行结果：
--Generic Animal makes a sound.
--Buddy barks.