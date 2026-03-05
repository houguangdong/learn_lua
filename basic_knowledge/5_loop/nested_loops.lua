#!/usr/local/bin/lua
--Lua 循环嵌套
--Lua 循环 Lua 循环
--Lua 编程语言中允许循环中嵌入循环。以下实例演示了 Lua 循环嵌套的应用。
--语法
--Lua 编程语言中 for 循环嵌套语法格式:
--for init,max/min value, increment
--    do
--    for init,max/min value, increment
--    do
--        statements
--    end
--    statements
--end
--
--Lua 编程语言中 while 循环嵌套语法格式:
--while(condition)
--do
--    while(condition)
--    do
--        statements
--    end
--    statements
--end
--
--Lua 编程语言中 repeat...until 循环嵌套语法格式:
--
--repeat
--    statements
--    repeat
--        statements
--    until( condition )
--until( condition )
--除了以上同类型循环嵌套外，我们还可以使用不同的循环类型来嵌套，如 for 循环体中嵌套 while 循环。

--实例
--以下实例使用了for循环嵌套:
--实例
j =2
for i=2,10 do
    for j=2,(i/j) , 2 do
        if(not(i%j))
        then
            break
        end
        if(j > (i/j))then
            print("i 的值为：",i)
        end
    end
end