--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/core/server/callbacks/events.lua
--- @description Handles client callback requests and executes registered server callbacks.

--- @section Imports

local callbacks = require("src.core.server.callbacks.functions")

--- @section Events

RegisterServerEvent("rig:server:trigger_callback")
AddEventHandler("rig:server:trigger_callback", function(name, data, cb_id)
    local src = source
    local callback = callbacks.get(name)

    if not callback then
        print(("[callbacks] Callback not found: %s"):format(name))
        TriggerClientEvent("rig:client:callback_response", src, cb_id, nil)
        return
    end

    callback(src, data, function(response)
        TriggerClientEvent("rig:client:callback_response", src, cb_id, response)
    end)
end)