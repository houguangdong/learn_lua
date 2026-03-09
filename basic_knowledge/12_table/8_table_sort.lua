#!/usr/local/bin/lua

print('---------------------------------------------------------------------------------------------------------------')
--排序支持自定义排序规则，比如:
t = {
    [1] = {A = 5, B = 2},
    [2] = {A = 1, B = 3},
    [3] = {A = 3, B = 6},
    [4] = {A = 7, B = 1},
    [5] = {A = 2, B = 9},
}

table.sort(t, function(a, b)
        return a.A > b.A;
    end
)
for k, v in pairs(t) do
    print(k)
    for key, value in pairs(v) do
        print(key, value)
    end
end
print('---------------------------------------------------------------------------------------------------------------')
--table 泛型元素去重, 只要元素支持 == 比较。
--要写成完全的泛型，那么 v==a[i] 改成一个比较函数的指针 equal(v, a[i]):
function removeRepeated(a)
    for k, v in pairs(a) do
        local count = 0
        for j in pairs(a) do
            count = count + 1
        end
        for i=k+1, count do
            if v == a[i] then
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
print('---------------------------------------------------------------------------------------------------------------')
--排序自定义排序规则时，大体规则是传参数 (a，b)，当 return true 时，则 a 排在 b 前，否则相反。
local a3={2,3,5,52,6,74,4}
table.sort(a3, function(item11, item21) return item11>item21 end)
for k, v in ipairs(a3) do
    print(v)
end
-- 74 52 6 5 4 3 2
print('---------------------------------------------------------------------------------------------------------------')
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
print('---------------------------------------------------------------------------------------------------------------')