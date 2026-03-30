--[[
mongo会话事务接口支持子模块，可根据需要引入：
local mongo = require "mongo"
mongo.enable("transaction")
]]
local bson = require "bson"
local driver = require "skynet.mongo.driver"
local assert = assert
local table = table
local mongo = require "mongo"

local bson_encode =	bson.encode
local bson_encode_order	= bson.encode_order
local bson_decode =	bson.decode
local bson_int64 = bson.int64
local empty_bson = bson_encode {}

local M = {}

local function werror(r)
    local ok = (r.ok == 1 and not r.writeErrors and not r.writeConcernError and not r.errmsg)

    local err
    if not ok then
        if r.writeErrors then
            err = r.writeErrors[1].errmsg
        elseif r.writeConcernError then
            err = r.writeConcernError.errmsg
        else
            err = r.errmsg
        end
    end
    return ok, err, r
end

function M.init(depend)
    --[[
	要使用mongodb事务的前提是需要先将mongodb配置为副本集，否则报错：Transaction numbers are only allowed on a replica set member or mongos
	比如修改配置文件/etc/mongod.conf中：
	 replication:
	   replSetName: "rs0"
	然后重启monogod服务
	以下带下划线结尾的接口为内部私有接口，目前不宜应用层直接调用
	]]
    -- {
    --   id = {
    --     id = "000504301FB085921E4FF58C38E3F270922FFF",
    --   },
    --   timeoutMinutes = 30,
    --   ok = 1.0,
    -- }
    local mongo_db = depend.mongo_db
    assert("table" == type(mongo_db))
    ---@return table
    function mongo_db:startSession_()
        return self.runCommand("startSession") -- 由mongo服务器生成，避免自产生的id相同的冲突
    end

    ---@param session_id table
    function mongo_db:endSessions_(session_id)
        return self:runCommand("endSessions", {bson_encode(session_id)})
    end

    local transaction_id = 0
    ---@return integer
    local function startTransaction_()
        transaction_id = transaction_id + 1
        if transaction_id > 9999999 then
            transaction_id = 1
        end
        return transaction_id
    end

    ---@param session_id table
    ---@param transaction_id integer
    local function genTransactionParams(session_id, transaction_id, startTransaction)
        return "lsid", bson_encode(session_id),
            "txnNumber", bson_int64(transaction_id)         -- 这是此会话中的第一个事务，故从1开始 -- BSON field 'OperationSessionInfo.txnNumber' is the wrong type 'int', expected type 'long'
            ,"autocommit", false
            , startTransaction and "startTransaction" or nil, startTransaction and startTransaction or nil
    end
    -- 原始裸接口备用，考虑是否需要开放支持跨协程事务，但每个更新操作需手动额外调用runCommand来辅助实现，而不能调用原有相关接口(如safe_insert)
    -- ---@param session_id table
    -- ---@param transaction_id integer
    -- function mongo_client:commitTransaction_(session_id, transaction_id) -- commitTransaction may only be run against the admin database.
    -- 	return self:runCommand("commitTransaction", 1, "lsid", bson_encode(session_id), "txnNumber", bson_int64(transaction_id), "autocommit", false)
    -- end
    -- ---@param session_id table
    -- ---@param transaction_id integer
    -- function mongo_client:abortTransaction_(session_id, transaction_id)
    -- 	return self:runCommand("abortTransaction", 1, "lsid", bson_encode(session_id), "txnNumber", bson_int64(transaction_id), "autocommit", false) -- 如果不设置autocommit则报错：txnNumber may only be provided for multi-document transactions and retryable write commands. autocommit:false was not provided, and abortTransaction is not a retryable write command.
    -- end
    local cur_coroutine = coroutine.running
    local transaction = {}
    local function is_in_transaction()
        return transaction[cur_coroutine()]
    end
    local function get_cur_transaction_params()
        local TransactionParams = transaction[cur_coroutine()]
        assert(TransactionParams)
        return table.unpack(TransactionParams)
    end
    local function set_transaction_params(params)
        local TransactionParams = transaction[cur_coroutine()]
        assert(TransactionParams)
        table.move(TransactionParams, 1, #TransactionParams, #params + 1, params)
        -- startTransaction只设置一次为true
        while #TransactionParams > 6 do
            table.remove(TransactionParams)
        end
        -- table.insert(params, "writeConcern") -- writeConcern is not allowed within a multi-statement transaction
        -- table.insert(params, bson_encode({w=0}))
        return params
    end

    local debug_traceback = debug.traceback

end