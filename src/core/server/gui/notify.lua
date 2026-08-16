--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/server/gui/notify.lua
--- @description Server side notification handling, nothing special.

--- @section Functions

local function notify(source, opts)
    if not source or not opts then print("error", "notify: Invalid params provided.") return end

    TriggerClientEvent("rig:client:notify", source, opts)
end

exports("notify", notify)