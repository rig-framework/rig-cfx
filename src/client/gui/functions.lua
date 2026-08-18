--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/client/gui/functions.lua
--- @description Handles client-side GUI functions, UI builders, modals, notifications, and helpers.

--- @section Imports

local gui_functions = require("src.shared.gui.functions")

--- @section Initialisation

local m = {}

--- @section Notify

function m.notify(opts)
    if not opts then 
        print("error", locale(core.client.gui.notify_opts_missing)) 
        return 
    end

    SendNUIMessage({
        func = "notify",
        payload = opts
    })
end

--- @section Modal 

function m.build_modal(opts)
    if not opts then 
        print("error", locale(core.client.gui.modal_config_missing)) 
        return 
    end

    local safe_opts = gui_functions.sanitize(opts, "modal")
    if not safe_opts then 
        print("error", locale(core.client.gui.modal_sanitize_failed)) 
        return 
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        func = "build_modal",
        payload = safe_opts
    })
end

function m.close_modal(container)
    SetNuiFocus(false, false)
    SendNUIMessage({
        func = "remove_modal",
        payload = { container = container }
    })
end

--- @section UI Framework

function m.build_ui(ui)
    if not ui then
        print("error", locale(core.client.gui.ui_config_missing))
        return
    end

    local safe_ui = gui_functions.sanitize(ui, "ui")
    if not safe_ui then
        print("error", locale(core.client.gui.ui_sanitize_failed))
        return
    end

    SetNuiFocus(true, true)
    SendNUIMessage({ func = "build_ui", payload = safe_ui })
end

function m.close_ui()
    SendNUIMessage({ func = "close_ui" })
    SetNuiFocus(false, false)
end

return m