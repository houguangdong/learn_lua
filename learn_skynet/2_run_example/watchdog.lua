local skynet = require "skynet"

local CMD = {}
local SOCKET = {}
local gate
local agent = {}


function CMD.start(conf)
    return skynet.call(gate, "lua", "open", conf)
end

skynet.start(function()
    skynet.dispatch("lua", function(session, source, cmd, subcmd, ...)
        if cmd == "socket" then
            local f = SOCKET[subcmd]
            f(...)
            -- socket api don't need return
        else
            local f = assert(CMD[cmd])
            skynet.ret(skynet.pack(f(subcmd, ...)))
        end
    end)

    gate = skynet.newservice("gate")
end)