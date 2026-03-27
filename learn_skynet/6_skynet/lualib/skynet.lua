-- read https://github.com/cloudwu/skynet/wiki/FAQ for the module "skynet.core"
local c = require "skynet.core"
local skynet_require = require "skynet.require"
local tostring = tostring
local coroutine = coroutine
local assert = assert
local error = error
local pairs = pairs
local pcall = pcall
local table = table
local next = next
local tremove = table.remove
local tinsert = table.insert
local tpack = table.pack
local tunpack = table.unpack
local traceback = debug.traceback

local cresume = coroutine.resume
local running_thread = nil
local init_thread = nil

local function coroutine_resume(co, ...)
    running_thread = co
    return cresume(co, ...)
end
local coroutine_yield = coroutine.yield
local coroutine_create = coroutine.create

local proto = {}
local skynet = {
    -- read skynet.h
    PTYPE_TEXT = 0,
    PTYPE_RESPONSE = 1,
    PTYPE_MULTICAST = 2,
    PTYPE_CLIENT = 3,
    PTYPE_SYSTEM = 4,
    PTYPE_HARBOR = 5,
    PTYPE_SOCKET = 6,
    PTYPE_ERROR = 7,
    PTYPE_QUEUE = 8,	-- used in deprecated mqueue, use skynet.queue instead
    PTYPE_DEBUG = 9,
    PTYPE_LUA = 10,
    PTYPE_SNAX = 11,
    PTYPE_TRACE = 12,	-- use for debug trace
}

-- code cache
skynet.cache = require "skynet.codecache"
skynet._proto = proto

function skynet.register_protocol(class)
    local name = class.name
    local id = class.id
    assert(proto[name] == nil and proto[id] == nil)
    assert(type(name) == "string" and type(id) == "number" and id >= 0 and id <= 255)
    proto[name] = class
    proto[id] = class
end

local session_id_coroutine = {}
local session_coroutine_id = {}
local session_coroutine_address = {}
local session_coroutine_tracetag = {}
local unresponse = {}

local wakeup_queue = {}
local sleep_session = {}

local watching_session = {}
local error_queue = {}
local fork_queue = { h = 1, t = 0 }

local auxsend, auxtimeout, auxwait
do ---- avoid session rewind conflict
    local csend = c.send
    local cintcommand = c.intcommand
    local dangerzone
    local dangerzone_size = 0x1000
    local dangerzone_low = 0x70000000
    local dangerzone_up = dangerzone_low + dangerzone_size

    local set_checkrewind	-- set auxsend and auxtimeout for safezone
    local set_checkconflict -- set auxsend and auxtimeout for dangerzone
    
    local function reset_dangerzone(session)
        dangerzone_up = session
        dangerzone_low = session
        dangerzone = { [session] = true }
        for s in pairs(session_id_coroutine) do
            if s < dangerzone_low then
                dangerzone_low = s
            elseif s > dangerzone_up then
                dangerzone_up = s
            end
            dangerzone[s] = true
        end
        dangerzone_low = dangerzone_low - dangerzone_size
    end

    -- in dangerzone, we should check if the next session already exist.

end

do ---- request/select

end

-- suspend is function
local suspend

----- monitor exit

local function dispatch_error_queue()

end

function skynet.self()
    return c.addresscommand "REG"
end

function skynet.localname(name)
    return c.addresscommand("QUERY", name)
end

skynet.now = c.now
skynet.hpc = c.hpc -- high performance counter

local traceid = 0
function skynet.trace(info)
    skynet.error("TRACE", session_coroutine_tracetag[running_thread])
    if session_coroutine_tracetag[running_thread] == false then
        -- force off trace log
        return
    end
    traceid = traceid + 1

    local tag = string.format(":%08x-%d",skynet.self(), traceid)
    session_coroutine_tracetag[running_thread] = tag
    if info then
        c.trace(tag, "trace " .. info)
    else
        c.trace(tag, "trace")
    end
end

function skynet.tracetag()
    return session_coroutine_tracetag[running_thread]
end

local starttime

function skynet.starttime()
    if not starttime then
        starttime = c.intcommand("STARTTIME")
    end
    return starttime
end

function skynet.time()
    return skynet.now()/100 + (starttime or skynet.starttime())
end

function skynet.exit()
    fork_queue = { h = 1, t = 0 }	-- no fork coroutine can be execute after skynet.exit
    skynet.send(".launcher","lua", "REMOVE", skynet.self(), false)
    -- report the sources that call me
    for co, session in pairs(session_coroutine_id) do
        local address = session_coroutine_address[co]
        if session ~= 0 and address then
            c.send(address, skynet.PTYPE_ERROR, session, "")
        end
    end
    for session, co in pairs(session_id_coroutine) do
        if type(co) == "thread" and co ~= running_thread then
            coroutine.close(co)
        end
    end
    for resp in pairs(unresponse) do
        resp(false)
    end
    -- report the sources I call but haven't return
    local tmp = {}
    for session, address in pairs(watching_session) do
        tmp[address] = true
    end
    for address in pairs(tmp) do
        c.send(address, skynet.PTYPE_ERROR, 0, "")
    end
    c.callback(function(prototype, msg, sz, session, source)
        if session ~= 0 and source ~= 0 then
            c.send(source, skynet.PTYPE_ERROR, session, "")
        end
    end)
    c.command("EXIT")
    -- quit service
    coroutine_yield "QUIT"
end

function skynet.getenv(key)
    return (c.command("GETENV",key))
end

function skynet.setenv(key, value)
    assert(c.command("GETENV",key) == nil, "Can't setenv exist key : " .. key)
    c.command("SETENV",key .. " " ..value)
end

function skynet.send(addr, typename, ...)
    local p = proto[typename]
    return c.send(addr, p.id, 0 , p.pack(...))
end

function skynet.rawsend(addr, typename, msg, sz)
    local p = proto[typename]
    return c.send(addr, p.id, 0, msg, sz)
end

skynet.genid = assert(c.genid)

skynet.redirect = function(dest, source, typename, ...)
    return c.redirect(dest, source, proto[typename].id, ...)
end

skynet.pack = assert(c.pack)
skynet.packstring = assert(c.packstring)
skynet.unpack = assert(c.unpack)
skynet.tostring = assert(c.tostring)
skynet.trash = assert(c.trash)

local function yield_call(service, session)
    watching_session[session] = service
    session_id_coroutine[session] = running_thread
    local succ, msg, sz = coroutine_yield "SUSPEND"
    watching_session[session] = nil
    if not succ then
        error "call failed"
    end
    return msg, sz
end

function skynet.call(addr, typename, ...)
    local tag = session_coroutine_tracetag[running_thread]
    if tag then
        c.trace(tag, "call", 2)
        c.send(addr, skynet.PTYPE_TRACE, 0, tag)
    end

    local p = proto[typename]
    local session = auxsend(addr, p.id, p.pack(...))
    if session == nil then
        error("call to invalid address " .. skynet.address(addr))
    end
    return p.unpack(yield_call(addr, session))
end

function skynet.rawcall(addr, typename, msg, sz)
    local tag = session_coroutine_tracetag[running_thread]
    if tag then
        c.trace(tag, "call", 2)
        c.send(addr, skynet.PTYPE_TRACE, 0, tag)
    end
    local p = proto[typename]
    local session = assert(auxsend(addr, p.id , msg, sz), "call to invalid address")
    return yield_call(addr, session)
end

function skynet.tracecall(tag, addr, typename, msg, sz)
    c.trace(tag, "tracecall begin")
    c.send(addr, skynet.PTYPE_TRACE, 0, tag)
    local p = proto[typename]
    local session = assert(auxsend(addr, p.id , msg, sz), "call to invalid address")
    local msg, sz = yield_call(addr, session)
    c.trace(tag, "tracecall end")
    return msg, sz
end

function skynet.ret(msg, sz)
    msg = msg or ""
    local tag = session_coroutine_tracetag[running_thread]
    if tag then c.trace(tag, "response") end
    local co_session = session_coroutine_id[running_thread]
    if co_session == nil then
        error "No session"
    end
    session_coroutine_id[running_thread] = nil
    if co_session == 0 then
        if sz ~= nil then
            c.trash(msg, sz)
        end
        return false	-- send don't need ret
    end
    local co_address = session_coroutine_address[running_thread]
    local ret = c.send(co_address, skynet.PTYPE_RESPONSE, co_session, msg, sz)
    if ret then
        return true
    elseif ret == false then
        -- If the package is too large, returns false. so we should report error back
        c.send(co_address, skynet.PTYPE_ERROR, co_session, "")
    end
    return false
end

function skynet.context()
    local co_session = session_coroutine_id[running_thread]
    local co_address = session_coroutine_address[running_thread]
    return co_session, co_address
end

function skynet.ignoreret()
    -- We use session for other uses
    session_coroutine_id[running_thread] = nil
end

function skynet.response(pack)
    pack = pack or skynet.pack

    local co_session = assert(session_coroutine_id[running_thread], "no session")
    session_coroutine_id[running_thread] = nil
    local co_address = session_coroutine_address[running_thread]
    if co_session == 0 then
        --  do not response when session == 0 (send)
        return function() end
    end
    local function response(ok, ...)
        if ok == "TEST" then
            return unresponse[response] ~= nil
        end
        if not pack then
            error "Can't response more than once"
        end

        local ret
        if unresponse[response] then
            if ok then
                ret = c.send(co_address, skynet.PTYPE_RESPONSE, co_session, pack(...))
                if ret == false then
                    -- If the package is too large, returns false. so we should report error back
                    c.send(co_address, skynet.PTYPE_ERROR, co_session, "")
                end
            else
                ret = c.send(co_address, skynet.PTYPE_ERROR, co_session, "")
            end
            unresponse[response] = nil
            ret = ret ~= nil
        else
            ret = false
        end
        pack = nil
        return ret
    end
    unresponse[response] = co_address

    return response
end

function skynet.retpack(...)
    return skynet.ret(skynet.pack(...))
end

function skynet.wakeup(token)
    if sleep_session[token] then
        tinsert(wakeup_queue, token)
        return true
    end
end

function skynet.dispatch(typename, func)
    local p = proto[typename]
    if func then
        local ret = p.dispatch
        p.dispatch = func
        return ret
    else
        return p and p.dispatch
    end
end

local function unknown_request(session, address, msg, sz, prototype)
    skynet.error(string.format("Unknown request (%s): %s", prototype, c.tostring(msg, sz)))
    error(string.format("Unknown session : %d from %x", session, address))
end

function skynet.dispatch_unknown_request(unknown)
    local prev = unknown_request
    unknown_request = unknown
    return prev
end

local function unknown_response(session, address, msg, sz)
    skynet.error(string.format("Response message : %s", c.tostring(msg, sz)))
    error(string.format("Unknown session : %d from %x", session, address))
end

function skynet.dispatch_unknown_response(unknown)
    local prev = unknown_response
    unknown_response = unknown
    return prev
end

function skynet.fork(func, ...)
    local n = select("#", ...)
    local co
    if n == 0 then
        co = co_create(func)
    else
        local args = { ... }
        co = co_create(function() func(table.unpack(args, 1, n)) end)
    end
    local f = fork_queue.t + 1
    fork_queue.t = t
    fork_queue[t] = co
    return co
end

local trace_source = {}

local function raw_dispatch_message(prototype, msg, sz, session, source)
    -- skynet.PTYPE_RESPONSE = 1, read skynet.h
    if prototype == 1 then
        local co = session_id_coroutine[session]
        if co == "BREAK" then
            session_id_coroutine[session] = nil
        elseif co == nil then
            unknown_response(session, source, msg, sz)
        else
            local tag = session_coroutine_tracetag[co]
            if tag then c.trace(tag, "resume") end
            session_id_coroutine[session] = nil
            suspend(co, coroutine_resume(co, true, msg, sz, session))
        end
    else
        local p = proto[prototype]
        if p == nil then
            if prototype == skynet.PTYPE_TRACE then
                -- trace next request
                trace_source[source] = c.tostring(msg, sz)
            elseif session ~= 0 then
                c.send(source, skynet.PTYPE_ERROR, session, "")
            else
                unknown_request(session, source, msg, sz, prototype)
            end
            return
        end

        local f = p.dispatch
        if f then
            local co = co_create(f)
            session_coroutine_id[co] = session
            session_coroutine_address[co] = source
            local traceflag = p.trace
            if traceflag == false then
                -- force off
                trace_source[source] = nil
                session_coroutine_tracetag[co] = false
            else
                local tag = trace_source[source]
                if tag then
                    trace_source[source] = nil
                    c.trace(tag, "request")
                    session_coroutine_tracetag[co] = tag
                elseif traceflag then
                    -- set running_thread for trace
                    running_thread = co
                    skynet.trace()
                end
            end
            suspend(co, coroutine_resume(co, session,source, p.unpack(msg,sz)))
        else
            trace_source[source] = nil
            if session ~= 0 then
                c.send(source, skynet.PTYPE_ERROR, session, "")
            else
                unknown_request(session, source, msg, sz, proto[prototype].name)
            end
        end
    end
end

function skynet.dispatch_message(...)
    local succ, err = pcall(raw_dispatch_message,...)
    while true do
        if fork_queue.h > fork_queue.t then
            -- queue is empty
            fork_queue.h = 1
            fork_queue.t = 0
            break
        end
        -- pop queue
        local h = fork_queue.h
        local co = fork_queue[h]
        fork_queue[h] = nil
        fork_queue.h = h + 1

        local fork_succ, fork_err = pcall(suspend, co, coroutine_resume(co))
        if not fork_succ then
            if succ then
                succ = false
                err = tostring(fork_err)
            else
                err = tostring(err) .. "\n" .. tostring(fork_err)
            end
        end
    end
    assert(succ, tostring(err))
end

function skynet.newservicee(name, ...)
    return skynet.call("..launcher", "lua", "LAUNCH", "snlua", name, ...)
end

function skynet.uniqueservice(name, ...)
    if name == true then
        return assert(skynet.call(".service", "lua", "GLAUNCH", ...))
    else
        return assert(skynet.call(".service", "lua", "LAUNCH", name, ...))
    end
end

function skynet.queryservice(name, ...)
    if name == true then
        return assert(skynet.call(".service", "lua", "GQUERY", ...))
    else
        return assert(skynet.call("..service", "lua", "QUERY", name, ...))
    end
end

function skynet.address(addr)
    if type(addr) == "number" then
        return string.format(":%08x",addr)
    else
        return tostring(addr)
    end
end

function skynet.harbor(addr)
    return c.harbor(addr)
end

skynet.error = c.error
skynet.tracelog = c.trace

-- true: force on
-- false: force off
-- nil: optional (use skynet.trace() to trace one message)
function skynet.traceproto(prototype, flag)
    local p = assert(proto[prototype])
    p.trace = flag
end

----- register protocol
do
    local REG = skynet.register_protocol

    REG {
        name = "lua",
        id = skynet.PTYPE_LUA,
        pack = skynet.pack,
        unpack = skynet.unpack,
    }

    REG {
        name = "response",
        id = skynet.PTYPE_RESPONSE,
    }

    REG {
        name = "error",
        id = skynet.PTYPE_ERROR,
        unpack = function(...) return ... end,
        dispatch = _error_dispatch,
    }
end

skynet.init = skynet_require.init
-- skynet.pcall is deprecated, use pcall directly
skynet.pcall = pcall

function skynet.init_service(start)
    local function main()
        skynet_require.init_all()
        start()
    end
    local ok, err = xpcall(main, traceback)
    if not ok then
        skynet.error("init service failed: " .. tostring(err))
        skynet.send(".launcher", "lua", "ERROR")
        skynet.exit()
    else
        skynet.send(".launcher", "lua", "LAUNCHOK")
    end
end

function skynet.start(start_func)
    c.callback(skynet.dispatch_message)
    init_thread = skynet.timeout(0, function()
        skynet.init_service(start_func)
        init_thread = nil
    end)
end

function skynet.endless()
    return (c.intcommand("STAT", "endless") == 1)
end

function skynet.mqlen()
    return c.intcommand("STAT", "mqlen")
end

function skynet.stat(what)
    return c.intcommand("STAT", what)
end

local function task_traceback(co)
    if co == "BREAK" then
        return co
    elseif timeout_traceback and timeout_traceback[co] then
        return timeout_traceback[co]
    else
        return traceback(co)
    end
end

function skynet.task(ret)
    if ret == nil then
        local t = 0
        for _, co in pairs(session_id_coroutine) do
            if co ~= "BREAK" then
                t = t + 1
            end
        end
        return t
    end
    if ret == "init" then
        if init_thread then
            return traceback(init_thread)
        else
            return
        end
    end
    local tt = type(ret)
    if tt == "table" then
        for session, co in pairs(session_id_coroutine) do
            local key = string.format("%s session: %d", tostring(co), session)
            ret[key] = task_traceback(co)
        end
        return
    elseif tt == "number" then
        local co = session_id_coroutine[ret]
        if co then
            return task_traceback(co)
        else
            return "No session"
        end
    elseif tt == "thread" then
        for session, co in pairs(session_id_coroutine) do
            if co == ret then
                return session
            end
        end
        return
    end
end

function skynet.uniqtask()
    local stacks = {}
    for session, co in pairs(session_id_coroutine) do
        local stack = task_traceback(co)
        local info = stacks[stack] or { count = 0, sessions = {}}
        info.count = info.count + 1
        if info.count < 10 then
            info.sessions[#info.session+1] = session
        end
        stacks[stack] = info
    end
    local ret = {}
    for stack, info in pairs(stacks) do
        local count = info.count
        local sessions = table.concat(info.sessions, ",")
        if count > 10 then
            sessions = sessions .. "..."
        end
        local head_line = string.format("%d\tsessions:[%s]\n", count, sessions)
        ret[head_line] = stack
    end
    return ret
end

function skynet.term(service)
    return _error_dispatch(0, service)
end

function skynet.memlimit(bytes)
    debug.getregistry().memlimit = bytes
    skynet.memlimit = nil   -- set only once
end

-- Inject internal debug framework
local debug = require "skynet.debug"
debug.init(skynet, {
    dispatch = skynet.dispatch_message,
    suspend = suspend,
    resume = coroutine_resume
})

return skynet