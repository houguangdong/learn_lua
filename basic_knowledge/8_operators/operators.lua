#!/usr/local/bin/lua
print('------------------------------------')
a = 21
b = 10
c = a + b
print("Line 1 - c 的值为 ", c )
c = a - b
print("Line 2 - c 的值为 ", c )
c = a * b
print("Line 3 - c 的值为 ", c )
c = a / b
print("Line 4 - c 的值为 ", c )
c = a % b
print("Line 5 - c 的值为 ", c )
c = a^2
print("Line 6 - c 的值为 ", c )
c = -a
print("Line 7 - c 的值为 ", c )

--在 lua 中，/ 用作除法运算，计算结果包含小数部分，// 用作整除运算，计算结果不包含小数部分：
print('------------------------------------')


a = 21
b = 10

if( a == b )
then
    print("Line 1 - a 等于 b" )
else
    print("Line 1 - a 不等于 b" )
end

if( a ~= b )
then
    print("Line 2 - a 不等于 b" )
else
    print("Line 2 - a 等于 b" )
end

if ( a < b )
then
    print("Line 3 - a 小于 b" )
else
    print("Line 3 - a 大于等于 b" )
end

if ( a > b )
then
    print("Line 4 - a 大于 b" )
else
    print("Line 5 - a 小于等于 b" )
end

-- 修改 a 和 b 的值
a = 5
b = 20
if ( a <= b )
then
    print("Line 5 - a 小于等于  b" )
end

if ( b >= a )
then
    print("Line 6 - b 大于等于 a" )
end

print('------------------------------------')
--逻辑运算符
a = true
b = true

if ( a and b )
then
    print("a and b - 条件为 true" )
end

if ( a or b )
then
    print("a or b - 条件为 true" )
end

print("---------分割线---------" )

-- 修改 a 和 b 的值
a = false
b = true

if ( a and b )
then
    print("a and b - 条件为 true" )
else
    print("a and b - 条件为 false" )
end

if ( not( a and b) )
then
    print("not( a and b) - 条件为 true" )
else
    print("not( a and b) - 条件为 false" )
end
print('------------------------------------')
--其他运算符
a = "Hello "
b = "World"

print("连接字符串 a 和 b ", a..b )

print("b 字符串长度 ",#b )

print("字符串 Test 长度 ",#"Test" )

print("菜鸟教程网址长度 ",#"www.runoob.com" )

print('------------------------------------')
--运算符优先级
a = 20
b = 10
c = 15
d = 5

e = (a + b) * c / d;-- ( 30 * 15 ) / 5
print("(a + b) * c / d 运算值为  :",e )

e = ((a + b) * c) / d; -- (30 * 15 ) / 5
print("((a + b) * c) / d 运算值为 :",e )

e = (a + b) * (c / d);-- (30) * (15/5)
print("(a + b) * (c / d) 运算值为 :",e )

e = a + (b * c) / d;  -- 20 + (150/5)
print("a + (b * c) / d 运算值为   :",e )