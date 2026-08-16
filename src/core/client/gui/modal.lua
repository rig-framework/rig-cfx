--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/client/gui/modal.lua
--- @description Client side modal handling, nothing special.

--- @section Imports

local gui_functions = require("src.core.shared.gui.functions")

--- @section Function

local function build_modal(opts)
    if not opts then 
        print("error", "build_modal: Modal config missing.") 
        return 
    end

    local safe_opts = gui_functions.sanitize(opts, "modal")
    if not safe_opts then 
        print("error", "build_modal: Modal config wasn't returned after sanitize.") 
        return 
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        func = "build_modal",
        payload = safe_opts
    })
end

exports("build_modal", build_modal)

--- @section Events

RegisterNetEvent("rig:client:build_modal", function(opts)
    if not opts then return print("error", "build_modal: opts missing") end
    build_modal(opts)
end)

