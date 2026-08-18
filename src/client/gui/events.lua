--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/client/gui/events.lua
--- @description Inbound network events

--- @section Imports

local gui = require("src.client.gui.functions")

--- @section General

RegisterNetEvent("rig:client:remove_focus", function()
    SetNuiFocus(false, false)
end)

--- @section Notify

RegisterNetEvent("rig:client:notify", function(opts)
    if not opts then return print("error", locale(core.client.gui.notify_opts_missing)) end
    
    gui.notify(opts)
end)

--- @section Modal

RegisterNetEvent("rig:client:build_modal", function(opts)
    if not opts then return print("error", locale(core.client.gui.modal_opts_missing)) end

    gui.build_modal(opts)
end)

RegisterNetEvent("rig:client:close_modal", function(container)
    if not container then container = "#ui_focus" end
    gui.close_modal(container)
end)

--- @section UI Framework

RegisterNetEvent("rig:client:build_ui", function(opts)
    if not opts then return print("error", locale(core.client.gui.ui_opts_missing)) end
    
    gui.build_ui(opts)
end)

RegisterNetEvent("rig:client:close_ui", function()
    gui.close_ui()
end)