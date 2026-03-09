#!/usr/local/bin/lua

--5	table.sort (table [, comp])
--对给定的table进行升序排序。


print('------------------------------------')
--Table 排序
--以下实例演示了 sort() 方法的使用，用于对 Table 进行排序：
fruits = {"banana", "orange", "apple", "grapes"}
print("排序前")
for k, v in ipairs(fruits) do
    print(k, v)
end

table.sort(fruits)
print("排序后")
for k, v in ipairs(fruits) do
    print(k, v)
end