--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/server/commands/events.lua
--- @description Sends registered command chat suggestions to requesting clients.

--- @section Imports

local CommandRegistry = require("src.core.server.commands.registry")

--- @section Events

RegisterServerEvent("rig:server:get_command_suggestions")
AddEventHandler("rig:server:get_command_suggestions", function()
    local _src = source
    TriggerClientEvent("chat:addSuggestions", _src, CommandRegistry.get_formatted_suggestions())
end)