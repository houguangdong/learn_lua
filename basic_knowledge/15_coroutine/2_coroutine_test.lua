#!/usr/local/bin/lua

print('------------------------------------coroutine.status-----------------------------------------------------------')
--以下实例演示了以上各个方法的用法：
--coroutine_test.lua文件
-- 创建了一个新的协同程序对象 co，其中协同程序函数打印传入的参数 i
co = coroutine.create(
    function(i)
        print(i);
    end
)

print(coroutine.status(co)) --suspend延缓

-- 使用 coroutine.resume 启动协同程序 co 的执行，并传入参数 1。协同程序开始执行，打印输出为 1
coroutine.resume(co, 1) --1
-- 通过 coroutine.status 检查协同程序 co 的状态，输出为 dead，表示协同程序已经执行完毕
print(coroutine.status(co)) --dead
print("-----------------------------coroutine.wrap--------------------------------------------------------------------")
-- 使用 coroutine.wrap 创建了一个协同程序包装器，将协同程序函数转换为一个可直接调用的函数对象
co = coroutine.wrap(
    function(i)
        print(i);
    end
)

co(1)
print('---------------------------------------------------------------------------------------------------------------')
-- 创建了另一个协同程序对象 co2，其中的协同程序函数通过循环打印数字 1 到 10，在循环到 3 的时候输出当前协同程序的状态和正在运行的线程
co2 = coroutine.create(
    function()
        for i=1,10 do
            print(i)
            if i == 3 then
                print(coroutine.status(co2))    --running
                print(coroutine.running())      --thread:xxx
            end
            coroutine.yield()
        end
    end
)

-- 连续调用 coroutine.resume 启动协同程序 co2 的执行
coroutine.resume(co2)
coroutine.resume(co2)
coroutine.resume(co2)

-- 通过 coroutine.status 检查协同程序 co2 的状态，输出为 suspended，表示协同程序暂停执行
print(coroutine.status(co2)) -- suspended
print(coroutine.running())

--以上实例执行输出结果为：
--1
--dead
------------
--1
------------
--1
--2
--3
--running
--thread: 0x7fb801c05868    false
--suspended
--thread: 0x7fb801c04c88    true
--------
--coroutine.running就可以看出来,coroutine在底层实现就是一个线程。
--当create一个coroutine的时候就是在新线程中注册了一个事件。
--当使用resume触发事件的时候，create的coroutine函数就被执行了，当遇到yield的时候就代表挂起当前线程，等候再次resume触发事件。
print('---------------------------------------------------------------------------------------------------------------')