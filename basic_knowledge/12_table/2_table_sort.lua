#!/usr/local/bin/lua

--table 去重
function table.unique(t, bArray)
    local seen = {}
    local result = {}
    local idx = 1

    for _, v in ipairs(t) do           -- 改用 ipairs 保证顺序
        if not seen[v] then
            seen[v] = true
            if bArray then
                result[idx] = v             -- 用连续数字下标 → 变成普通数组
                idx = idx + 1
            else
                result[v] = true          -- 或者 result[k] = v 看你需求     -- 保留原来的key（但因为去重用的是值，所以更常见是 n[v] = v 或 n[v] = true）
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
print('------------------------------------')
-- 或者更简单：
for k, v in ipairs(table.unique(arr, true)) do
    print(k, v)
end

print('------------------------------------')
-- 传 true
local a = table.unique(arr, true)
-- 结果大概率是：{ [1]=1, [2]=2, [3]=4, [4]=5, [5]=3, [6]=6 }
-- 可以用 ipairs 按顺序遍历

-- 不传或传 false/nil
local b = table.unique(arr)
-- 结果大概率是：{ [1]=1, [2]=2, [4]=4, [5]=5, [3]=3, [6]=6 }
-- 只能用 pairs 遍历，顺序随机
print('------------------------------------')

--数组去重函数
function removeRepeat(a)
    local b = {}
    for k,v in ipairs(a) do
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
        print(k,v)
    end
end

--测试
arr = {1,1,1,2,4,5,3,2,5,3,6}
narr = removeRepeat(arr)
table.sort(narr)  --对数组排序
output(narr)
print('------------------------------------')
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
print('------------------------------------')
--排序支持自定义排序规则，比如:
t = {
    [1] = {A = 5, B = 2},
    [2] = {A = 1, B = 3},
    [3] = {A = 3, B = 6},
    [4] = {A = 7, B = 1},
    [5] = {A = 2, B = 9},
}

table.sort(t, function(a, b) return a.A > b.A; end)
for k, v in pairs(t) do
    print(k)
    for key, value in pairs(v) do
        print(key, value)
    end
end
print('------------------------------------')
--table 泛型元素去重, 只要元素支持 == 比较。
--要写成完全的泛型，那么 v==a[i] 改成一个比较函数的指针 equal(v,a[i]):
function removeRepeated(a)
    for k, v in pairs(a) do
        local count = 0
        for j in pairs(a) do
            count = count + 1
        end
        for i=k+1, count do
            if v==a[i] then
                table.remove(a, i)
            end
        end
    end
end
local a = {"a", "d", "c", "g", "d", "w", "c", "a", "g", "s"}
removeRepeated(a)
for k, v in pairs(a) do
    print(k, v)
end
print('------------------------------------')
--排序自定义排序规则时，大体规则是传参数 (a，b)，当 return true 时，则 a 排在 b 前，否则相反。
local a={2,3,5,52,6,74,4}
table.sort(a, function(item11, item21) return item11>item21 end)
for k,v in ipairs(a) do print(v) end
-- 74 52 6 5 4 3 2
print('------------------------------------')
--大家注意，函数传参类型为table时，是地址传递而不是值传递！
local function f(x)
    x["writable"] ="written"
end

local t = {
    ["readonly"]="read",
    ["writable"]="write"
}
print("before---------")
for k, v in pairs(t) do
    print(k, v)
end

f(t)
print("after----------")
for k,v in pairs (t) do
    print(k,v)
end