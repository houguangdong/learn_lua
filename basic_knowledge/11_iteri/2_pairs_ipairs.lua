#!/usr/local/bin/lua

print('---------------------------------------------pairs 和 ipairs区别-------------------------------------------------')
--pairs 和 ipairs区别
--pairs: 迭代 table，可以遍历表中所有的 key 可以返回 nil
--ipairs: 迭代数组，不能返回 nil,如果遇到 nil 则退出
local tab = {
    [1]="a",
    [3]="b",
    [4]="c"
}
for i, v in pairs(tab) do
    print(tab[i])
end
print("--------------")
for i, v in ipairs(tab) do -- 输出 "a", k=2时断开
    print(tab[i])
end
print('---------------------------------------------pairs 和 ipairs异同-------------------------------------------------')
--pairs 和 ipairs异同
--同：都是能遍历集合（表、数组）
--异：ipairs 仅仅遍历值，按照索引升序遍历，索引中断停止遍历。即不能返回 nil,只能返回数字 0，如果遇到 nil 则退出。它只能遍历到集合中出现的第一个不是整数的 key。
--pairs 能遍历集合的所有元素。即 pairs 可以遍历集合中所有的 key，并且除了迭代器本身以及遍历表本身还可以返回 nil
local tabFiles = {
    [1] = "test2",
    [6] = "test3",
    [4] = "test1"
}

for k, v in ipairs(tabFiles) do    --输出"test2",在key等于2处断开
    print(k, v)
end
print('---------------------------------------------------------------------------------------------------------------')
local tabFiles = {
    [2] = "test2",
    [6] = "test3",
    [4] = "test1"
}
for k, v in ipairs(tabFiles) do  --[[什么都没输出，为什么？因为控制变量初始值是按升序来遍历的，当key为1时，value为nil，此时便停止了遍历， 所有什么结果都没输出]]--
    print(k, v)
end
print("--------------")
local tabFiles = {
    [2] = "test2",
    [6] = "test3",
    [4] = "test1"
}
for k, v in pairs(tabFiles) do  --输出2 test2, 6 test3, 4 test1
    print(k, v)
end
print('---------------------------------------------------------------------------------------------------------------')
local tabFiles = {"alpha", "beta", [3] = "no", ["two"] = "yes"}  for i, v in ipairs(tabFiles ) do    --输出前三个   备注：因为第四个key不是整数
    print( tabFiles [i] )
end
print("--------------")
for i,v in pairs(tabFiles ) do    --全部输出
    print( tabFiles [i] )
end
print('---------------------------------------------------------------------------------------------------------------')
function split(str, delimiter)
    local dLen = string.len(delimiter)
    local newDeli = ''
    for i=1,dLen,1 do
        print(string.sub(delimiter,i,i))
        newDeli = newDeli .. "["..string.sub(delimiter,i,i).."]"
        print(newDeli)
    end

    local locaStart,locaEnd = string.find(str,newDeli)
    print(locaStart, locaEnd)
    local arr = {}
    local n = 1
    while locaStart ~= nil
    do
        if locaStart>0 then
            arr[n] = string.sub(str,1,locaStart-1)
            n = n + 1
        end

        str = string.sub(str,locaEnd+1,string.len(str))
        locaStart,locaEnd = string.find(str,newDeli)
    end
    if str ~= nil then
        arr[n] = str
    end
    return arr
end
t = split("php,js,hd,df", ",")
for k, v in pairs(t) do
    print(k, v)
end
