#!/usr/local/bin/lua
--以下实例执行 while 循环，在变量 a 小于 20 时输出 a 的值，并在 a 大于 15 时终止执行循环：

--[ 定义变量 --]
a = 10

--[ while 循环 --]
while( a < 20 )
do
    print("a 的值为:", a)
    a=a+1
    if( a > 15)
    then
        --[ 使用 break 语句终止循环 --]
        break
    end
end