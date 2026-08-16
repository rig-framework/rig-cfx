--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/core/server/gui/events.lua
--- @description Receives gui actions forwarded from the client when not registered client-side.

--- @section Imports

local gui_registry = require("src.core.shared.gui.registry")

--- @section Events

RegisterServerEvent("rig:server:gui_handler")
AddEventHandler("rig:server:gui_handler", function(data)
    local src = source

    if not data or not data.action then
        print(("[rig:gui] server handler: missing action (source %s)"):format(src))
        return
    end

    local success, result = pcall(gui_registry.call_registered_function, data.action, data)
    if not success then
        print(("[rig:gui] server handler: function call failed for %s (source %s) - %s"):format(data.action, src, result))
    end
end)