--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/core/client/gui/nui_callbacks.lua
--- @description NUI -> client callback bridge. Generic action dispatch through the shared gui registry.

--- @section Imports

local gui_registry = require("src.core.shared.gui.registry")

--- @section NUI Callbacks

RegisterNUICallback("gui:remove_focus", function()
    print("info", locale(core.client.gui.focus_cleared))
    SetNuiFocus(false, false)
end)

RegisterNUICallback("gui:handler", function(data, cb)
    print("info", locale(core.client.gui.handler_invoked, json.encode(data)))

    if not data or not data.action then
        if cb then cb(false) end
        return
    end

    if gui_registry.has_function(data.action) then
        local success, result = pcall(gui_registry.call_registered_function, data.action, data)
        if not success then
            print("error", locale(core.client.gui.handler_failed, result))
        end
    else
        TriggerServerEvent("rig:server:gui_handler", data)
    end

    if data.should_close then
        SetNuiFocus(false, false)
    end
    
    if cb then cb(true) end
end)