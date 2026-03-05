#!/usr/local/bin/lua
print('------------------------------------')
--单引号间的一串字符。
local str1 = 'This is a string.'
local str2 = "This is also a string."
--双引号间的一串字符。
local str = "Hello, "
str = str .. "World!"  -- 创建一个新的字符串并将其赋值给str
print(str)  -- 输出 "Hello, World!"
----[[ 与 ]] 间的一串字符。
local multilineString = [[
This is a multiline string.
It can contain multiple lines of text.
No need for escape characters.
]]

print(multilineString)
print('------------------------------------')
--以上三种方式的字符串实例如下：
string1 = "Lua"
print("\"字符串 1 是\"",string1)
string2 = 'runoob.com'
print("字符串 2 是",string2)
string3 = [["Lua 教程"]]
print("字符串 3 是",string3)
print('------------------------------------')
--字符串长度计算
--在 Lua 中，要计算字符串的长度（即字符串中字符的个数），你可以使用 string.len函数或 utf8.len 函数，包含中文的一般用 utf8.len，string.len 函数用于计算只包含 ASCII 字符串的长度。
local myString = "Hello, RUNOOB!"
-- 计算字符串的长度（字符个数）
local length = string.len(myString)
print(length) -- 输出 14
print('------------------------------------')
--以上实例的 myString 字符串只包含 ASCII 字符，因此 string.len 函数可以准确地返回字符串的长度。
--包含中文的字符串使用 utf8.len函数：
local myString = "Hello, 世界!"

-- 计算字符串的长度（字符个数）
local length1 = utf8.len(myString)
print(length1) -- 输出 10

-- string.len 函数会导致结果不准确
local length2 = string.len(myString)
print(length2) -- 输出 14
print('------------------------------------')
--字符串操作
--Lua 提供了很多的方法来支持字符串的操作：
--序号	方法 & 用途
--1
string.upper(argument)
--字符串全部转为大写字母。
--2
string.lower(argument)
--字符串全部转为小写字母。
--3
string.gsub(mainString,findString,replaceString,num)
--在字符串中替换。
--mainString 为要操作的字符串， findString 为被替换的字符，replaceString 要替换的字符，num 替换次数（可以忽略，则全部替换），如：
string.gsub("aaaa","a","z",3);
--zzza    3
--4	string.find (str, substr, [init, [plain]])
--在一个指定的目标字符串 str 中搜索指定的内容 substr，如果找到了一个匹配的子串，就会返回这个子串的起始索引和结束索引，不存在则返回 nil。
--init 指定了搜索的起始位置，默认为 1，可以一个负数，表示从后往前数的字符个数。
--plain 表示是否使用简单模式，默认为 false，true 只做简单的查找子串的操作，false 表示使用使用正则模式匹配。
--以下实例查找字符串 "Lua" 的起始索引和结束索引位置：
string.find("Hello Lua user", "Lua", 1)
--7    9
--5
string.reverse(arg)
--字符串反转
string.reverse("Lua")
--auL
--6
string.format(...)
--返回一个类似printf的格式化字符串
string.format("the value is:%d",4)
--the value is:4
--7 string.char(arg) 和 string.byte(arg[,int])
--char 将整型数字转成字符并连接， byte 转换字符为整数值(可以指定某个字符，默认第一个字符)。
string.char(97,98,99,100)
--abcd
string.byte("ABCD",4)
--68
string.byte("ABCD")
--65
--8	string.len(arg)
--计算字符串长度。
string.len("abc")
--9	string.rep(string, n)
--返回字符串string的n个拷贝
string.rep("abcd",2)
--abcdabcd
--10	..
--链接两个字符串
print("www.runoob.".."com")
--www.runoob.com
--11	string.gmatch(str, pattern)
--返回一个迭代器函数，每一次调用这个函数，返回一个在字符串 str 找到的下一个符合 pattern 描述的子串。如果参数 pattern 描述的字符串没有找到，迭代函数返回nil。
for word in string.gmatch("Hello Lua user", "%a+") do print(word) end
--12	string.match(str, pattern, init)
--string.match()只寻找源字串str中的第一个配对. 参数init可选, 指定搜寻过程的起点, 默认为1。
--在成功配对时, 函数将返回配对表达式中的所有捕获结果; 如果没有设置捕获标记, 则返回整个配对字符串. 当没有成功的配对时, 返回nil。
string.match("I have 2 questions for you.", "%d+ %a+")
--2 questions
string.format("%d, %q", string.match("I have 2 questions for you.", "(%d+) (%a+)"))
--2, "questions"

print('------------------------------------')
--字符串截取
--字符串截取使用 sub() 方法。
--string.sub() 用于截取字符串，原型为：
--string.sub(s, i [, j])
--参数说明：
--    s：要截取的字符串。
--    i：截取开始位置。
--    j：截取结束位置，默认为 -1，最后一个字符。

-- 字符串
local sourcestr = "prefix--runoobgoogletaobao--suffix"
print("\n原始字符串", string.format("%q", sourcestr))

-- 截取部分，第4个到第15个
local first_sub = string.sub(sourcestr, 4, 15)
print("\n第一次截取", string.format("%q", first_sub))

-- 取字符串前缀，第1个到第8个
local second_sub = string.sub(sourcestr, 1, 8)
print("\n第二次截取", string.format("%q", second_sub))

-- 截取最后10个
local third_sub = string.sub(sourcestr, -10)
print("\n第三次截取", string.format("%q", third_sub))

-- 索引越界，输出原始字符串
local fourth_sub = string.sub(sourcestr, -100)
print("\n第四次截取", string.format("%q", fourth_sub))

--以上代码执行结果为：
--原始字符串    "prefix--runoobgoogletaobao--suffix"
--第一次截取    "fix--runoobg"
--第二次截取    "prefix--"
--第三次截取    "ao--suffix"
--第四次截取    "prefix--runoobgoogletaobao--suffix"
print('------------------------------------')
--字符串大小写转换
--以下实例演示了如何对字符串大小写进行转换：
--实例
string1 = "Lua";
print(string.upper(string1))
print(string.lower(string1))
print('------------------------------------')
--字符串查找与反转
--以下实例演示了如何对字符串进行查找与反转操作：
--实例
string = "Lua Tutorial"
-- 查找字符串
print(string.find(string,"Tutorial"))
reversedString = string.reverse(string)
print("新字符串为",reversedString)
print('------------------------------------')

