#!/usr/local/bin/lua

--table 去重
function table.unique(t, bArray)
    local seen = {}
    local result = {}
    local idx = 1

    for _, v in ipairs(t) do               -- 改用 ipairs 保证顺序
        if not seen[v] then
            seen[v] = true
            if bArray then
                result[idx] = v             -- 用连续数字下标 → 变成普通数组
                idx = idx + 1
            else
                result[v] = true            -- 或者 result[k] = v 看你需求     -- 保留原来的key（但因为去重用的是值，所以更常见是 n[v] = v 或 n[v] = true）
            end
        end
    end

    return result
end

--测试
arr = {1,1,1,2,4,5,3,2,5,3,6}
-- 推荐用法（得到顺序数组）
local unique_arr = table.unique(arr, true)
for k, v in ipairs(unique_arr) do
    print(k, v)
end
print(arr)
print('---------------------------------------------------------------------------------------------------------------')
arr1 = {1,1,1,2,4,5,3,2,5,3,6}
-- 或者更简单：
new_arr1 = {}
for k, v in ipairs(table.unique(arr1, false)) do
    print(k, v)
    new_arr1[k] = k
end
print(table.unpack(new_arr1))
print(table.concat(new_arr1, "-"))
print('---------------------------------------------------------------------------------------------------------------')
-- 传 true
local aa = table.unique(arr, true)
-- 结果大概率是：{ [1]=1, [2]=2, [3]=4, [4]=5, [5]=3, [6]=6 }
-- 可以用 ipairs 按顺序遍历
print('-----------------------')
-- 不传或传 false/nil
local bb = table.unique(arr)
-- 结果大概率是：{ [1]=1, [2]=2, [4]=4, [5]=5, [3]=3, [6]=6 }
-- 只能用 pairs 遍历，顺序随机
print('--------------------------------------------数组去重函数----------------------------------------------------------')
function removeRepeat(a)
    local b = {}
    for k, v in ipairs(a) do
        if(#b == 0) then
            b[1]=v;
        else
            local index = 0
            for i=1,#b do
                if(v == b[i]) then
                    break
                end
                index = index + 1
            end
            if(index == #b) then
                b[#b + 1] = v;
            end
        end
    end
    return b
end

--遍历数组输出
function output(o)
    for k,v in ipairs(o) do
        print(k, v)
    end
end

--测试
arr = {1,1,1,2,4,5,3,2,5,3,6}
narr = removeRepeat(arr)
table.sort(narr)  --对数组排序
output(narr)
print('---------------------------------------------------------------------------------------------------------------')
-- table 去重
my_numbers = {1, 2, 3, 4, 20, 6, 7, 7, 15, 28};
function table_unique(t)
    local check = {};
    local n = {};
    for key, value in pairs(t) do
        if not check[value] then
            n[key] = value
            check[value] = value
        end
    end
    return n
end

for key, value in pairs(table_unique(my_numbers)) do
    print('value is ' , value)
end