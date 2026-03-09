#!/usr/local/bin/lua

--2	table.insert (table, [pos,] value):
--在table的数组部分指定位置(pos)插入值为value的一个元素. pos参数可选, 默认为数组部分末尾.

fruits = {"banana", "orange", "apple"}
print('------------------------------------')
--插入和移除
--以下实例演示了 table 的插入和移除操作:
-- 在末尾插入
table.insert(fruits, "mango")
print("索引为4的元素为", fruits[4])

--在索引为2的键处插入
table.insert(fruits, 2, "grapes")
print("索引为 2 的元素为 ", fruits[2])
print("最后一个元素为 ", fruits[5])
table.remove(fruits)
print("移除后最后一个元素为 ", fruits[5])