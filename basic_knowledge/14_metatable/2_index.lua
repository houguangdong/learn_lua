#!/usr/local/bin/lua

print("-----------------------------------------__index 元方法----------------------------------------------------------")
--这是 metatable 最常用的键。
--当你通过键来访问 table 的时候，如果这个键没有值，那么Lua就会寻找该table的metatable（假定有metatable）中的__index 键。
--如果__index包含一个表格，Lua会在表格中查找相应的键。
--我们可以在使用 lua 命令进入交互模式查看：
--    $ lua
--    Lua 5.3.0  Copyright (C) 1994-2015 Lua.org, PUC-Rio
--    > other = { foo = 3 }
--    > t = setmetatable({}, { __index = other })
--    > t.foo
--    3
--    > t.bar
--    nil

--如果__index包含一个函数的话，Lua就会调用那个函数，table和键会作为参数传递给函数。
--__index 元方法查看表中元素是否存在，如果不存在，返回结果为 nil；如果存在则由 __index 返回结果。
mytable = setmetatable({key1 = "value1"}, {
    __index = function(mytable, key)
        if key == "key2" then
            return "metatablevalue"
        else
            return nil
        end
    end
})

print(mytable.key1, mytable.key2)
--实例解析：
--    mytable 表赋值为 {key1 = "value1"}。
--    mytable 设置了元表，元方法为 __index。
--    在mytable表中查找 key1，如果找到，返回该元素，找不到则继续。
--    在mytable表中查找 key2，如果找到，返回 metatablevalue，找不到则继续。
--    判断元表有没有__index方法，如果__index方法是一个函数，则调用该函数。
--    元方法中查看是否传入 "key2" 键的参数（mytable.key2已设置），如果传入 "key2" 参数返回 "metatablevalue"，否则返回 mytable 对应的键值。
print("---------------------------------------------------------------------------------------------------------------")
--我们可以将以上代码简单写成：
mytable = setmetatable({key1 = "value1"}, { __index = { key2 = "metatablevalue" } })
print(mytable.key1, mytable.key2)
--总结
--Lua 查找一个表元素时的规则，其实就是如下 3 个步骤:
--    1.在表中查找，如果找到，返回该元素，找不到则继续
--    2.判断该表是否有元表，如果没有元表，返回 nil，有元表则继续。
--    3.判断元表有没有 __index 方法，如果 __index 方法为 nil，则返回 nil；如果 __index 方法是一个表，则重复 1、2、3；如果 __index 方法是一个函数，则返回该函数的返回值。
--该部分内容来自作者寰子：https://blog.csdn.net/xocoder/article/details/9028347
print("---------------------------------------------------------------------------------------------------------------")