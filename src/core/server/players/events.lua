--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/server/events/player.lua
--- @description Handles active in-game player sessions, routing buckets, drops, and resource lifecycles.

--- @section Imports

local UserRegistry = require("src.core.server.users.registry")
local PlayerRegistry = require("src.core.server.players.registry")

local utils = require("src.core.server.utils")

--- @section Events

RegisterServerEvent("rig:server:disconnect", function()
    local _src = source
    local msg = locale and locale("core.server.players.disconnected") or "Disconnected."
    DropPlayer(_src, msg)
end)

--- @section Event Handlers

AddEventHandler("playerJoining", function()
    local _src = source
    local ids = utils.get_identifiers(_src)

    if ids.license then
        if UserRegistry:activate(_src, ids.license) then
            PlayerRegistry:assign_personal_bucket(_src)
            PlayerRegistry:create(_src)
        end
    end
end)

AddEventHandler("playerDropped", function(reason)
    local _src = source

    PlayerRegistry:remove(_src)
    UserRegistry:remove(_src)
end)

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    PlayerRegistry:save_all()
end)