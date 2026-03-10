#!/usr/local/bin/lua

--为表添加操作符
--以下实例演示了两表相加操作：
--自定义计算表中最大键值函数 table_maxn，即返回表最大键值
function table_maxn(t)
    local mn = 0
    for k, _ in pairs(t) do
        if type(k) == "number" and k > mn then
            mn = k
        end
    end
    return mn
end

-- 两表相加操作
mytable = setmetatable({ 1, 2, 3 }, {
    __add = function(mytable, newtable)
        local max_key_mytable = table_maxn(mytable)
        for i = 1, table_maxn(newtable) do
            table.insert(mytable, max_key_mytable + i, newtable[i])
        end
        return mytable
    end
})

secondtable = {4, 5, 6}

mytable = mytable + secondtable

for k, v in ipairs(mytable) do
    print(k, v)
end
--以上实例执行输出结果为：
--1    1
--2    2
--3    3
--4    4
--5    5
--6    6
--__add 键包含在元表中，并进行相加操作。 表中对应的操作列表如下：(注意：__是两个下划线)
print('---------------------------------------------------------------------------------------------------------------')