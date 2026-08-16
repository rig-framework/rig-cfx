--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/core/client/gui/functions.lua
--- @description Handles client-side GUI functions, UI builders, modals, notifications, and helpers.

--- @section Imports

local gui_functions = require("src.core.shared.gui.functions")

--- @section Initialisation

local m = {}

--- @section Notify

function m.notify(opts)
    if not opts then 
        print("[rig:gui] notify: Options missing.") 
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
        print("[rig:gui] build_modal: Modal config missing.") 
        return 
    end

    local safe_opts = gui_functions.sanitize(opts, "modal")
    if not safe_opts then 
        print("[rig:gui] build_modal: Modal config wasn't returned after sanitize.") 
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
        print("[rig:gui] build_ui: ui config missing")
        return
    end

    local safe_ui = gui_functions.sanitize(ui, "ui")
    if not safe_ui then
        print("[rig:gui] build_ui: ui config wasn't returned after sanitize")
        return
    end

    SetNuiFocus(true, true)
    SendNUIMessage({ func = "build_ui", payload = safe_ui })
end

function m.close_ui()
    SendNUIMessage({ func = "close_ui" })
    SetNuiFocus(false, false)
end

function m.update_slots(items)
    if type(items) ~= "table" then
        print("[rig:gui] update_slots: invalid items table")
        return
    end

    local safe_items = gui_functions.sanitize(items, "inventory_update")
    SendNUIMessage({ func = "update_slots", items = safe_items })
end

function m.update_grid(items, section_key)
    if type(items) ~= "table" then
        print("[rig:gui] update_grid: invalid items table")
        return
    end

    local safe_items = gui_functions.sanitize(items, "inventory_update")
    SendNUIMessage({ func = "update_grid", items = safe_items, section_key = section_key })
end

return m