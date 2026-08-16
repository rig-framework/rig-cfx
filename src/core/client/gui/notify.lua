--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/client/gui/notify.lua
--- @description Client side notification handling, nothing special.

--- @section Functions

local function notify(opts)
    if not opts then print("error", "notify: Options missing.") return end

    SendNUIMessage({
        func = "notify",
        payload = opts
    })
end

exports("notify", notify)

--- @section Events

RegisterNetEvent("rig:client:notify", function(opts)
    notify(opts)
end)