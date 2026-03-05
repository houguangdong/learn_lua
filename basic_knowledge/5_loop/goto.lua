--Lua 语言中的 goto 语句允许将控制流程无条件地转到被标记的语句处。

--以下实例在判断语句中使用 goto：
local a = 1
::label:: print("--- goto label ---")

a = a+1
if a < 3 then
    goto label   -- a 小于 3 的时候跳转到标签 label
end
--从输出结果可以看出，多输出了一次 --- goto label ---。
print('------------------------------------')

i = 0
::s1:: do
    print(i)
    i = i+1
end
if i>3 then
    os.exit()   -- i 大于 3 时退出
end
goto s1

--有了 goto，我们可以实现 continue 的功能：
for i=1, 3 do
    if i <= 2 then
        print(i, "yes continue")
        goto continue
    end
    print(i, " no continue")
    ::continue::
    print([[i'm end]])
end
print('------------------------------------')
--lua 中没有 continue 语句有点不习惯。
--可以使用类似下面这种方法实现 continue 语句：
for i = 10, 1, -1 do
    repeat
        if i == 5 then
            print("continue code here")
            break
        end
        print(i, "loop code here")
    until true
end
print('-----------')
--continue 可以用 goto :
for i=1, 3 do
    if i <= 2 then
        print(i, "yes continue")
        goto continue
    end
    print(i, " no continue")
    ::continue::
    print([[i'm end]])
end
print('-----------')
--if else 就能完成 continue 语句:
for i=1, 3 do
    print(i)
    if i <= 2 then
        print("continue the loop")
    else
        print(" loop area")
end
print("end of loop")
end


--无限循环
--在循环体中如果条件永远为 true 循环语句就会永远执行下去，以下以 while 循环为例：
--实例
while( true )
do
    print("循环将永远执行下去")
end