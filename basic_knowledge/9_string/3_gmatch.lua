#!/usr/local/bin/lua

-- 定义函数（你提供的代码）
local function split_cmdline(cmdline)
    local split = {}
    --%S：表示任何一个非空白字符
    for i in string.gmatch(cmdline, "%S+") do   --返回一个迭代器函数，每一次调用这个函数，返回一个在字符串 str 找到的下一个符合 pattern 描述的子串。如果参数 pattern 描述的字符串没有找到，迭代函数返回nil。
        table.insert(split, i)
    end
    return split
end

-- 示例 1：普通命令 + 参数
local cmd1 = "login user123 password456"
local result1 = split_cmdline(cmd1)
print(table.concat(result1, "|"))      --concat是concatenate(连锁, 连接)的缩写. table.concat()函数列出参数中指定table的数组部分从start位置到end位置的所有元素, 元素间以指定的分隔符(sep)隔开。
print(select(2, table.unpack(result1)))
print("---------------------------------------------------------------------------------------------------------------")
-- 示例 2：带多个空格
local cmd2 = "move     100   200   north"
local result2 = split_cmdline(cmd2)
for i, v in ipairs(result2) do
    print(i, v)
end
print("---------------------------------------------------------------------------------------------------------------")
-- 示例 3：带引号的字符串（注意：当前函数不会处理引号）
local cmd3 = 'say "hello world" to everyone'
local result3 = split_cmdline(cmd3)
print(#result3)
print(table.concat(result3, " - "))
-- 输出： say - "hello - world" - to - everyone
-- （引号被当作普通字符，不会合并成一个参数）
print("---------------------------------------------------------------------------------------------------------------")
-- 示例 4：只有一个单词
local cmd4 = "help"
local result4 = split_cmdline(cmd4)
print(result4[1])        -- help
print(#result4)          -- 1
print("---------------------------------------------------------------------------------------------------------------")
-- 示例 5：空字符串或全是空格
local cmd5 = "   "
local result5 = split_cmdline(cmd5)
print(#result5)          -- 0 （空表）
print("---------------------------------------------------------------------------------------------------------------")
-- 示例 6：常见的游戏指令风格
local cmd6 = "/give @p diamond_sword 1 name:&6神剑 lore:很厉害的剑"
local result6 = split_cmdline(cmd6)
print(table.concat(result6, "\n"))
-- 输出（每行一个）：
-- /give
-- @p
-- diamond_sword
-- 1
-- name:&6神剑
-- lore:很厉害的剑