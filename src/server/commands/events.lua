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

local commands = require("src.server.commands.functions")

--- @section Events

RegisterServerEvent("rig:server:get_command_suggestions")
AddEventHandler("rig:server:get_command_suggestions", function()
    local _src = source
    TriggerClientEvent("chat:addSuggestions", _src, commands.get_command_suggestions())
end)