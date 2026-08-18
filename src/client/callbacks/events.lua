--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/client/callbacks/events.lua
--- @description Handles server callback responses and executes the client-side callback.

--- @section Imports

local callbacks = require("src.client.callbacks.functions")

--- @section Events

RegisterNetEvent("rig:client:callback_response")
AddEventHandler("rig:client:callback_response", function(id, response)
    callbacks.resolve(id, response)
end)