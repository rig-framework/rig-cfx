--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/core/client/gui/events.lua
--- @description Inbound network events

--- @section Imports

local gui = require("src.core.client.gui.functions")

--- @section General

RegisterNetEvent("rig:client:remove_focus", function()
    SetNuiFocus(false, false)
end)

--- @section Notify

RegisterNetEvent("rig:client:notify", function(opts)
    gui.notify(opts)
end)

--- @section Modal

RegisterNetEvent("rig:client:build_modal", function(opts)
    if not opts then return print("error", "build_modal: opts missing") end
    gui.build_modal(opts)
end)

RegisterNetEvent("rig:client:close_modal", function(container)
    if not container then container = "#ui_focus" end
    gui.close_modal(container)
end)

--- @section UI Framework

RegisterNetEvent("rig:client:build_ui", function()
    gui.build_ui(ui)
end)

RegisterNetEvent("rig:client:close_ui", function()
    gui.close_ui()
end)