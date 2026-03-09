#!/usr/local/bin/lua

--序号	方法 & 用途
--1	table.concat(table [, sep [, start [, end]]]):
--concat是concatenate(连锁, 连接)的缩写. table.concat()函数列出参数中指定table的数组部分从start位置到end位置的所有元素, 元素间以指定的分隔符(sep)隔开。

--接下来我们来看下这几个方法的实例。
--Table 连接
--我们可以使用 concat() 方法来连接两个 table:
fruits = {"banana", "orange", "apple"}
-- 返回 table 连接后的字符串
print("连接后的字符串", table.concat(fruits))
-- 指定连接字符
print("连接后的字符串", table.concat(fruits, ", "))
-- 指定索引来连接 table
print("连接后的字符串", table.concat(fruits, "-", 2, 3))