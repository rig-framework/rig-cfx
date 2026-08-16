--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/core/server/gui/functions.lua
--- @description Handles server-side GUI functions, UI builders, modals, notifications, and helpers.

--- @section Initialisation

local m = {}

--- @section Notify

function m.notify(source, opts)
    if not source or not opts then 
        print("error", locale(core.server.gui.notify_invalid_params)) 
        return 
    end

    TriggerClientEvent("rig:client:notify", source, opts)
end

--- @section Modal

function m.build_modal(source, opts)
    if not source or not opts then
        print("error", locale(core.server.gui.modal_params_missing))
        return
    end
    TriggerClientEvent("rig:client:build_modal", source, opts)
end

function m.close_modal(source, container)
    if not source then
        print("error", locale(core.server.gui.modal_source_missing))
        return
    end
    TriggerClientEvent("rig:client:close_modal", source, container)
end

--- @section UI Framework

function m.build_ui(source, ui)
    if not source or not ui then
        print("error", locale(core.server.gui.ui_invalid_params))
        return
    end

    TriggerClientEvent("rig:client:build_ui", source, ui)
end

function m.close_ui(source)
    if not source then
        print("error", locale(core.server.gui.ui_source_missing))
        return
    end

    TriggerClientEvent("rig:client:close_ui", source)
end

return m