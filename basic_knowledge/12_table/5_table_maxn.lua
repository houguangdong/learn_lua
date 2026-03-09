#!/usr/local/bin/lua

--Table 操作
--以下列出了 Table 操作常用的方法：
--序号	方法 & 用途
--3	table.maxn (table)
--指定table中所有正数key值中最大的key值. 如果不存在key值为正数的元素, 则返回0。(Lua5.2之后该方法已经不存在了,本文使用了自定义函数实现)
--
--4	table.remove (table [, pos])
--返回table数组部分位于pos位置的元素. 其后的元素会被前移. pos参数可选, 默认为table长度, 即从最后一个元素删起。

print('------------------------------------')
--Table 最大值
--table.maxn 在 Lua5.2 之后该方法已经不存在了，我们定义了 table_maxn 方法来实现。
--以下实例演示了如何获取 table 中的最大值：
function table_maxn(t)
    local mn = nil;
    for k, v in pairs(t) do
        if(mn == nil) then
            mn = v
        end
        if mn < v then
            mn = v
        end
    end
    print("xxxxxx", mn)
    return mn
end

tbl = {[1] = 2, [2] = 6, [3] = 34, [26] = 5}
print("tbl最大值", table_maxn(tbl))
print("tbl长度", #tbl)
print('------------------------------------')
--注意：
--当我们获取 table 的长度的时候无论是使用 # 还是 table.getn 其都会在索引中断的地方停止计数，而导致无法正确取得 table 的长度。
--可以使用以下方法来代替：
function table_leng(t)
    local leng = 0
    for k, v in pairs(t) do
        leng = leng + 1
    end
    return leng
end

print("tbl长度1", table_leng(tbl))
print('------------------------------------')