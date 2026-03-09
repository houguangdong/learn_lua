#!/usr/local/bin/lua

--__tostring 元方法
--__tostring 元方法用于修改表的输出行为。以下实例我们自定义了表的输出内容：
--实例
mytable = setmetatable({ 10, 20, 30 }, {
    __tostring = function(mytable)
        sum = 0
        for k, v in pairs(mytable) do
            sum = sum + v
        end
        return "表所有元素的和为 " .. sum
    end
})
print(mytable)
--以上实例执行输出结果为：
--表所有元素的和为 60
--从本文中我们可以知道元表可以很好的简化我们的代码功能，所以了解 Lua 的元表，可以让我们写出更加简单优秀的 Lua 代码。
print('---------------------------------------------------------------------------------------------------------------')