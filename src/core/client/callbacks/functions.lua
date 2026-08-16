--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/core/client/callbacks/functions.lua
--- @description Triggers server-side callbacks from the client.

--- @section Imports

local PendingRegistry = require("src.core.client.callbacks.registry")

--- @section Initialisation

local m = {}
local cb_id = 0

--- @section Functions

function m.trigger(name, data, cb)
    if type(cb) ~= "function" then return end
    cb_id = cb_id + 1
    PendingRegistry:set("pending", cb_id, cb)
    TriggerServerEvent("rig:server:trigger_callback", name, data, cb_id)
end

function m.resolve(id, response)
    local callback = PendingRegistry:get("pending", id)

    if not callback then
        print("error", locale(core.client.callbacks.callback_missing, id))
        return
    end

    PendingRegistry:remove("pending", id)
    callback(response)
end

return m