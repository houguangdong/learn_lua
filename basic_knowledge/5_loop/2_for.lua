#!/usr/local/bin/lua
--重复执行指定语句，重复次数可在 for 语句中控制。
print('------------------------------------')
--数值for循环
--Lua 编程语言中数值 for 循环语法格式:
--for var=exp1,exp2,exp3 do
--    <执行体>
--end
--var 从 exp1 变化到 exp2，每次变化以 exp3 为步长递增 var，并执行一次 "执行体"。exp3 是可选的，如果不指定，默认为1。
print('------------------------------------')
--实例
--for i=1,f(x) do
--    print(i)
--end

for i=10,1,-1 do
    print(i)
end
print('------------------------------------')
--for的三个表达式在循环开始前一次性求值，以后不再进行求值。比如上面的f(x)只会在循环开始前执行一次，其结果用在后面的循环中。
--验证如下:
--实例
function f(x)
    print("function")
    return x*2
end

for i=1,f(5) do print(i)
end
--可以看到 函数f(x)只在循环开始前执行一次。
print('------------------------------------')
--泛型for循环
--泛型 for 循环通过一个迭代器函数来遍历所有值，类似 java 中的 foreach 语句。
--Lua 编程语言中泛型 for 循环语法格式:
--打印数组a的所有值
a = {"one", "two", "three"}
for i, v in ipairs(a) do
    print(i, v)
end
--i是数组索引值，v是对应索引的数组元素值。ipairs是Lua提供的一个迭代器函数，用来迭代数组。

--实例
--循环数组 days：
days = {"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"}
for i,v in ipairs(days) do
    print(v)
end
print('------------------------------------')
--首先，ipairs 这个迭代器只能遍历所有数组下标的值，这是前提，也是和 pairs 的最根本区别，也就是说如果 ipairs 在迭代过程中是会直接跳过所有手动设定key值的变量。
--特别注意一点，和其他多数语言不同的地方是，迭代的下标是从1开始的。
tab = {1,2,a= nil,"d"}
for i,v in ipairs(tab) do
    print(i,v)
end
--这里是直接跳过了a=nil这个变量
print('------------------------------------')
--第二，ipairs在迭代过程中如果遇到nil时会直接停止。
--例如：
tab = {1,2,a= nil,nil,"d"}
for i,v in ipairs(tab) do
    print(i,v)
end
--这里会在遇到 nil 的时候直接跳出循环。
print('------------------------------------')
--for 循环中，循环的索引 i 为外部索引，修改循环语句中的内部索引 i，不会影响循环次数:
for i=1,10 do
    i = 10
    print("one time,i:"..i)
end
--仍然循环 10 次，只是 i 的值被修改了。

--pairs 能迭代所有键值对。
--ipairs 可以想象成 int+pairs，只会迭代键为数字的键值对。