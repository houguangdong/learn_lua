下面是 skynet.dispatch 的几个实用例子，直接可以复制到你的 Skynet 服务中使用。
1. 最常见、最标准的用法（推荐）
Lualocal skynet = require "skynet"

-- 这是最常见的写法，几乎所有 Skynet 服务都会这么写
skynet.start(function()
    -- 为 "lua" 协议（即 skynet.call / skynet.send 发来的消息）注册处理函数
    skynet.dispatch("lua", function(session, source, cmd, ...)
        -- session: 如果是 call 过来的，>0；如果是 send 过来的，通常是 0
        -- source: 发送方的服务地址
        -- cmd: 通常是命令字符串（如 "GET", "SET", "PING"）
        -- ...: 剩余参数

        skynet.error(string.format("收到来自 %s 的命令: %s", source, cmd))

        if cmd == "PING" then
            -- 无返回值（send 方式）
            -- skynet.ret() 可省略
        elseif cmd == "ECHO" then
            local arg = ...
            skynet.ret(skynet.pack("ECHO back: " .. tostring(arg)))   -- 返回值给 call
        elseif cmd == "ADD" then
            local a, b = ...
            skynet.ret(skynet.pack(a + b))
        else
            skynet.error("未知命令: " .. cmd)
            if session ~= 0 then
                skynet.ret()   -- call 过来的未知命令也要返回，否则对方会卡住
            end
        end
    end)

    skynet.register ".myservice"   -- 可选：注册服务名，方便其他服务查找
end)
2. 使用 CMD 表 的优雅写法（生产环境最推荐）
Lualocal skynet = require "skynet"

local CMD = {}

function CMD.ping()
    return "PONG"
end

function CMD.echo(text)
    return "echo: " .. text
end

function CMD.add(a, b)
    return a + b
end

skynet.start(function()
    skynet.dispatch("lua", function(session, source, cmd, ...)
        local f = CMD[cmd]
        if f then
            local ret = f(...)
            if session ~= 0 then
                skynet.ret(skynet.pack(ret))   -- 只在 call 时返回
            end
        else
            skynet.error("unknown command: " .. tostring(cmd))
        end
    end)
end)
3. 保存并替换原来的 dispatch（高级用法）
你的函数原型支持这个特性：
Lualocal old_dispatch = skynet.dispatch("lua")   -- 获取当前已注册的 dispatch

skynet.dispatch("lua", function(session, source, cmd, ...)
    skynet.error("【拦截日志】收到命令:", cmd)

    -- 调用原来的处理函数
    if old_dispatch then
        return old_dispatch(session, source, cmd, ...)
    end
end)
4. 其他协议的例子（不常用）
Lua-- 注册 "client" 协议（通常是 gate 转发来的客户端消息）
skynet.dispatch("client", function(fd, msg, sz)
    -- fd 是客户端 fd，msg/sz 是原始数据
    skynet.error("收到客户端消息 fd=", fd)
end)

-- 注册 "system" 协议（系统消息，如服务退出等）
skynet.dispatch("system", function(...)
    -- 处理系统事件
end)
小贴士

skynet.dispatch("lua", func) 是 必须 在 skynet.start() 里调用的。
收到 skynet.call 时必须用 skynet.ret(skynet.pack(...)) 返回，否则调用方会一直等待超时。
收到 skynet.send 时不用返回。
推荐一直使用 CMD 表 的方式，代码更清晰、易扩展。

把上面任意一个例子放到你的 .lua 服务文件中，重启 Skynet 后，其他服务就可以通过下面方式调用了：
Lualocal ret = skynet.call(service_address, "lua", "add", 3, 5)   -- 返回 8
skynet.send(service_address, "lua", "ping")
需要我再给你一个完整可运行的服务 + 调用方的例子吗？
#=======================================================================================================================
