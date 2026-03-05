#!/usr/local/bin/lua
print('------------------------------------')
--Lua 语言提供了以下几种循环处理方式：
--while  在条件为 true 时，让程序重复地执行某些语句。执行语句前会先检查条件是否为 true。
a=10
while( a < 20 )
do
    print("a 的值为:", a)
    a = a+1
end