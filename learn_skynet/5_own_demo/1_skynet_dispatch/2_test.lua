--下面是一个超级简单、单个文件的完整例子，直接复制保存为 test.lua 即可运行。
--示例：单个文件的最简版（推荐新手使用）
local skynet = require "skynet"

-- 定义命令处理表
local CMD = {}

function CMD.hello()
    return "你好，我是 Skynet 服务！"
end

function CMD.add(a, b)
    return a + b
end

function CMD.ping()
    return "PONG"
end

-- 使用 skynet.dispatch 注册消息处理
skynet.dispatch("lua", function(session, source, cmd, ...)
    local f = CMD[cmd]
    if f then
        local ret = f(...)
        if session ~= 0 then -- 如果是 call 请求，就返回结果
            skynet.ret(skynet.pack(ret))
        end
    else
        skynet.error("未知命令: " .. tostring(cmd))
        if session ~= 0 then
            skynet.ret() -- 必须返回，否则对方会卡死
        end
    end
end)

-- 服务启动入口
skynet.start(function()
    skynet.error("=== 测试服务启动成功 ===")

    -- 可选：注册一个名字，方便其他服务查找
    skynet.register(".testservice")
end)

--如何运行这个例子
--1 把上面代码保存为 test.lua
--2 在 Skynet 根目录下运行
--./skynet examples/config   # 或者你自己的配置文件
--3 启动后，在另一个服务或用 skynet.call 测试：
local addr = skynet.localname(".testservice")

print(skynet.call(addr, "lua", "hello"))
print(skynet.call(addr, "lua", "add", 6, 7))
print(skynet.call(addr, "lua", "ping"))
--这是目前最简单、最清晰的单个文件使用 skynet.dispatch 的例子。
--代码短、结构清楚、直接能跑。