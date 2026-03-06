#!/usr/local/bin/lua

--这一章的例子较难理解，如果把yield()和resume()两个函数的行为描述清楚了，就好理解多了。
--例子再简化一下：
co = coroutine.create(function (a)
    local r = coroutine.yield(a+1)        -- yield()返回a+1给调用它的resume()函数，即2
    print("r=" ..r)                       -- r的值是第2次resume()传进来的，100
end)
status, r = coroutine.resume(co, 1)     -- resume()返回两个值，一个是自身的状态true，一个是yield的返回值2
coroutine.resume(co, 100)     --resume()返回true
print('------------------------------------')
--coroutine.create方法和coroutine.wrap需要特别注意的是这个返回值的类型，功能上有些类似，但并不完全一样。
--coroutine.creat返回的是一个协同程序，类型为thread,需要使用coroutine.resume进行调用；而coroutine.wrap返回的是一个普通的方法(函数)，
--类型为function，和普通function有同样的使用方法，并且不能使用coroutine.resume进行调用。
--以下代码进行测试：
co_creat = coroutine.create(
    function()
        print("co_creat类型是"..type(co_creat))
    end
)

co_wrap = coroutine.wrap(
    function()
        print("co_wrap类型是"..type(co_wrap))
    end
)

coroutine.resume(co_creat)
co_wrap()
--输出：
--co_creat类型是thread
--co_wrap类型是function
print('------------------------------------')
--coroutine.resume方法需要特别注意的一点是，这个方法只要调用就会返回一个boolean值。
--coroutine.resume方法如果调用成功，那么返回true，如果有yield方法，同时返回yield括号里的参数; 如果失败，那么返回false，并且带上一句"cannot resume dead coroutine"
--以下代码进行测试：
co_yieldtest = coroutine.create(
    function()
        coroutine.yield()
        coroutine.yield(1)
        return 2
    end
)

for i = 1,4 do
    print("第"..i.."次调用协程:", coroutine.resume(co_yieldtest))
end
--输出：
--第1次调用协程:    true
--第2次调用协程:    true    1
--第3次调用协程:    true    2
--第4次调用协程:    false    cannot resume dead coroutine
print('------------------------------------')
--coroutine.create方法只要建立了一个协程 ，那么这个协程的状态默认就是suspend。使用resume方法启动后，会变成running状态；遇到yield时将状态设为suspend；如果遇到return，那么将协程的状态改为dead。
--coroutine.resume方法需要特别注意的一点是，这个方法只要调用就会返回一个boolean值。
--coroutine.resume方法如果调用成功，那么返回true；如果有yield方法，同时返回yield括号里的参数；如果没有yield，那么继续运行直到协程结束；直到遇到return，将协程的状态改为dead，并同时返回return的值。
--coroutine.resume方法如果调用失败(调用状态为dead的协程会导致失败)，那么返回false，并且带上一句"cannot resume dead coroutine"
--以下代码进行测试：
function yieldReturn(arg)
    return arg
end

co_yieldtest = coroutine.create(
    function()
        print("启动协程状态"..coroutine.status(co_yieldtest))
        print("--")
        coroutine.yield()
        coroutine.yield(1)
        coroutine.yield(print("第3次调用"))
        coroutine.yield(yieldReturn("第4次调用"))
        return 2
    end
)

print("启动前协程状态"..coroutine.status(co_yieldtest))
print("--")

for i = 1,6 do
    print("第"..i.."次调用协程:", coroutine.resume(co_yieldtest))
    print("当前协程状态"..coroutine.status(co_yieldtest))
    print("--")
end
--输出：
--启动前协程状态suspended
--
--启动协程状态running
--
--第1次调用协程:    true
--当前协程状态suspended
--
--第2次调用协程:    true    1
--当前协程状态suspended
--
--第3次调用
--第3次调用协程:    true
--当前协程状态suspended
--
--第4次调用协程:    true    第4次调用
--当前协程状态suspended
--
--第5次调用协程:    true    2
--当前协程状态dead
--
--第6次调用协程:    false    cannot resume dead coroutine
--当前协程状态dead
--
print('------------------------------------')
--挂起协程： yield 除了挂起协程外，还可以同时返回数据给 resume, 并且还可以同时定义下一次唤醒时需要传递的参数。
print();
cor = coroutine.create(function(a)
    print("参数 a值为：", a);
    local b, c = coroutine.yield(a + 1); --这里表示挂起协程，并且将a+1的值进行返回，并且指定下一次唤醒需要 b,c 两个参数。
    print("参数 b,c值分别为：", b, c);
    return b * c; --协程结束，并且返回 b*c 的值。
end);

print("第一次调用：", coroutine.resume(cor, 1));
print("第二次调用：", coroutine.resume(cor, 2, 2));
print("第三次调用：", coroutine.resume(cor));
--执行结果（结果中 true 表示本次调用成功）：
--参数 a值为：    1
--第一次调用：    true    2
--参数 b,c值分别为：    2    2
--第二次调用：    true    4
--第三次调用：    false    cannot resume dead coroutine
print('------------------------------------')
--正文中的例子分析：
--第一次调用（第一次调用的时候，协同程序是一个挂起的状态），resume 的参数 1,10 传入主体函数，打印得出 1,10，之后调用 foo 打印得出 2，程序挂起，之后返回这个值到 resume，作为第二个参数值为 4。
--第二次调用 resume 参数为 r ,从主函数中 print("第二次协同程序执行输出", r) 开始运行，因为此时的状态是挂起的状态，resume 的参数传入 yield，作为挂起点的返回值为 r。
--所以打印得出 r ,之后继续运行，执行 local r, s = coroutine.yield(a + b, a - b)，因为此时，并非 resume 直接调用的情况，所以 yield 函数 使用主函数传入的 a,b 参数 作为参数，得出结果为 11, -9，之后 再次挂起。
--结果: r 11 -9
--第三次调用 resume 参数为 x, y ,从程序挂起点运行，并参数传入 yield 中，yield 此时作为返回值点，所以得出 r,s 结果为 x , y，之后继续运行 return b, "结束协同程序" , 返回 b, 为 10。
--结果: x,y true, 10
--总结： resume 执行的情况如果（排除第一次执行情况）是挂起的状态，那么 resume 的参数传递给 yield，yield 不论参数表达式形式，返回的值 resume 传递的所有参数。
--特别的，注意如果运行之后，再次挂起，那么此时传入的 yield 值，就是主函数的参数值，如果使用的话。
--如果 resume 的执行是第一次（上面讲到排除第一次挂起的特殊情况）的情况或者是挂起之后再次运行，那么 resume 的参数 作为主函数的参数。