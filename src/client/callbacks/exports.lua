--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/client/callbacks/exports.lua
--- @description Client side export registration for callbacks.

local callbacks = require("src.client.callbacks.functions")

local function trigger(name, data, cb)
    return callbacks.trigger(name, data, cb)
end
exports("trigger_callback", trigger)