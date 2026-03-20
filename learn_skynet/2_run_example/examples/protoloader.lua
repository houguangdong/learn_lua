package.path = "./examples/?.lua;" .. package.path

local skynet = require "skynet"
local sprotoparser = require "sprotoparser"
local sprotoloader = require "sprotoloader"
local proto = require "proto"

skynet.start(function()
    sprotoparser.save(proto.c2s, 1)
    sprotoparser.save(proto.s2c, 2)
    -- don't call skynet.exit() , because sproto.core may unload and the global slot become invalid
end)