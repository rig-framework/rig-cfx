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
        print("error", locale(core.server.gui.missing_action, src))
        return
    end

    local success, result = pcall(gui_registry.call_registered_function, data.action, data)
    if not success then
        print("error", locale(core.server.gui.function_call_failed, data.action, src, result))
    end

    if data.should_close then
        TriggerClientEvent("rig:client:remove_focus", source)
    end
end)