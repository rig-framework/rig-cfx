--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/server/callbacks/exports.lua
--- @description Server side export registration for callbacks.

--- @section Imports

local callbacks = require("src.server.callbacks.functions")

--- @section Registration

local function register(name, cb)
    return callbacks.register(name, cb)
end
exports("register_callback", register)

--- @section Lookup

local function get(name)
    return callbacks.get(name)
end
exports("get_callback", get)