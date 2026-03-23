local msgserver = require "snax.msgserver"
local crypt = require "skynet.crypt"
local skynet = require "skynet"

local loginservice = tonumber(...)

local server = {}
local users = {}
local username_map = {}
local internal_id = 0

-- 登录服务器不允许多重登录，因此 login_handler 永远不会是可重入的
-- 由登录服务器调用
function server.login_handler(uid, secret)
    if users[uid] then
        error(string.format("%s is already login", uid))
    end

    internal_id = internal_id + 1
    local id = internal_id   -- don't use internal_id directly          唯一得id
    local username = msgserver.username(uid, id, servername) --去消息服务生成名字

    -- 您可以使用池来分配新的代理。
    local agent = skynet.newservice "msgagent"
    local u = {
        username = username,
        agent = agent,
        uid = uid,
        subid = id,
    }

    -- trash subid (no used)
    skynet.call(agent, "lua", "login", uid, id, secret)     --gate通过代理去访问登录服务器

    users[uid] = u
    username_map[username] = u

    msgserver.login(username, secret)   --去消息服务验证

    -- you should return unique subid
    return id
end

-- call by agent
function server.logout_handler(uid, subid)
    local u = users[uid]
    if u then
        local username = msgserver.username(uid, subid, servername)
        assert(u.servername == username)
        msgserver.logout(u.username)
        users[uid] = nil
        username_map[u.username] = nil
        skynet.call(loginservice, "lua", "logout", uid, subid)
    end
end

-- call by login server
function server.kick_handler(uid, subid)
    local u = users[uid]
    if u then
        local username = msgserver.username(uid, subid, servername)
        assert(u.username == username)
        -- NOTICE: logout may call skynet.exit, so you should use pcall.
        pcall(skynet.call, u.agent, "lua", "logout")
    end
end

-- call by self (when socket disconnect)
function server.disconnect_handler(username)
    local u = username_map[username]
    if u then
        skynet.call(u.agent, "lua", "afk")
    end
end

-- call by self (when recv a request from client)  自身调用（当收到客户端请求时)
function server.request_handler(username, msg)
    local u = username_map[username]
    return skynet.tostring(skynet.rawcall(u.agent, "client", msg))
end

-- call by self (when gate open)
function server.register_handler(name)
    servername = name
    skynet.call(loginservice, "lua", "register_gate", servername, skynet.self())
end

msgserver.start(server)
