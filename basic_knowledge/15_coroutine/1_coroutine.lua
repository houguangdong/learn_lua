#!/usr/local/bin/lua

--Lua 协同程序(coroutine)
--什么是协同(coroutine)？
--Lua 协同程序(coroutine)与线程比较类似：拥有独立的堆栈，独立的局部变量，独立的指令指针，同时又与其它协同程序共享全局变量和其它大部分东西。
--协同程序可以理解为一种特殊的线程，可以暂停和恢复其执行，从而允许非抢占式的多任务处理。
--协同是非常强大的功能，但是用起来也很复杂。
--
--基本语法
--协同程序由 coroutine 模块提供支持。
--
--使用协同程序，你可以在函数中使用 coroutine.create 创建一个新的协同程序对象，并使用 coroutine.resume 启动它的执行。
--协同程序可以通过调用 coroutine.yield 来主动暂停自己的执行，并将控制权交还给调用者。
--方法	                描述
--coroutine.create()	创建 coroutine，返回 coroutine，参数是一个函数，当和 resume 配合使用的时候就唤醒函数调用
--coroutine.resume()	重启 coroutine，和 create 配合使用
--coroutine.yield()	    挂起 coroutine，将 coroutine 设置为挂起状态，这个和 resume 配合使用能有很多有用的效果
--coroutine.status()	查看 coroutine 的状态
--                      注：coroutine 的状态有三种：dead，suspended，running，具体什么时候有这样的状态请参考下面的程序
--coroutine.wrap（）	    创建 coroutine，返回一个函数，一旦你调用这个函数，就进入 coroutine，和 create 功能重复
--coroutine.running()	返回正在跑的 coroutine，一个 coroutine 就是一个线程，当使用running的时候，就是返回一个 coroutine 的线程号
print('------------------------------------')
--以下实例演示了如何使用 Lua 协同程序：
function foo()
    print("协同程序 foo 开始执行")
    print('111111111111')
    local value = coroutine.yield("暂停 foo 的执行")
    print('222222222222')
    print("协同程序 foo 恢复执行，传入的值为: " .. tostring(value))
    print("协同程序 foo 结束执行")
end

-- 创建协同程序
local co = coroutine.create(foo)

-- 启动协同程序
local status, result = coroutine.resume(co) --重启 coroutine，和 create 配合使用
print(result) -- 输出: 暂停 foo 的执行

-- 恢复协同程序的执行，并传入一个值
status, result = coroutine.resume(co, 42)
print(result) -- 输出: 协同程序 foo 恢复执行，传入的值为: 42

--以上实例中，我们定义了一个名为 foo 的函数作为协同程序。在函数中，我们使用 coroutine.yield 暂停了协同程序的执行，并返回了一个值
--在主程序中，我们使用 coroutine.create 创建了一个协同程序对象，并使用 coroutine.resume 启动了它的执行。
--在第一次调用 coroutine.resume 后，协同程序执行到 coroutine.yield 处暂停，并将值返回给主程序。
--然后，我们再次调用 coroutine.resume，并传入一个值作为协同程序恢复执行时的参数。
--
--执行以上代码输出结果为：
--    协同程序 foo 开始执行
--    暂停 foo 的执行
--    协同程序 foo 恢复执行，传入的值为: 42
--    协同程序 foo 结束执行
--    nil
--需要注意的是，协同程序的状态可以通过 coroutine.status 函数获取，通过检查状态可以确定协同程序的执行情况（如运行中、已挂起、已结束等）。