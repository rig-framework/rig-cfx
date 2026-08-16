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
    if not source or not opts then print("error", "notify: Invalid params provided.") return end

    TriggerClientEvent("rig:client:notify", source, opts)
end

--- @section Modal

function m.build_modal(source, opts)
    if not source or not opts then
        print("error", "build_modal: Player source or opts missing")
        return
    end
    TriggerClientEvent("rig:client:build_modal", source, opts)
end

function m.close_modal(source, container)
    if not source then
        print("error", "close_modal: Player source missing")
        return
    end
    TriggerClientEvent("rig:client:close_modal", source, container)
end

--- @section UI Framework

function m.build_ui(source, ui)
    if not source or not ui then
        print("[rig:gui] build_ui: invalid params provided")
        return
    end

    TriggerClientEvent("rig:client:build_ui", source, ui)
end

function m.close_ui(source)
    if not source then
        print("[rig:gui] close_ui: player source missing")
        return
    end

    TriggerClientEvent("rig:client:close_ui", source)
end

return m