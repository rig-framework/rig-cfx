--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/server/cooldowns/functions.lua
--- @description Cooldown tracking and enforcement for player and global actions.
--- Server side enforced only.

--- @section Imports

local CooldownRegistry = require("src.server.cooldowns.registry")
local PlayerRegistry = require("src.server.players.registry")

--- @section Initialisation

local m = {}

--- @section Helpers

local function resolve_identity(source)
    local p = PlayerRegistry:get(source)
    if p and p.unique_id then
        return "id:" .. p.unique_id
    end

    return "src:" .. source
end

local function player_key(source, cooldown_type)
    return resolve_identity(source) .. ":" .. cooldown_type
end

--- @section Functions

function m.add_cooldown(source, cooldown_type, duration, is_global)
    local info = {
        end_time = os.time() + duration,
        resource = GetInvokingResource() or "unknown",
        source = source,
        cooldown_type = cooldown_type,
        is_global = is_global
    }

    if is_global then
        CooldownRegistry:set("global", cooldown_type, info)
    else
        CooldownRegistry:set("player", player_key(source, cooldown_type), info)
    end
end

function m.check_cooldown(source, cooldown_type, is_global)
    local info
    if is_global then
        info = CooldownRegistry:get("global", cooldown_type)
    else
        info = CooldownRegistry:get("player", player_key(source, cooldown_type))
    end

    return info ~= nil and os.time() < info.end_time
end

function m.clear_cooldown(source, cooldown_type, is_global)
    if is_global then
        CooldownRegistry:remove("global", cooldown_type)
    else
        CooldownRegistry:remove("player", player_key(source, cooldown_type))
    end
end

function m.clear_all_cooldowns()
    local now = os.time()

    for id, info in pairs(CooldownRegistry:get_all("player")) do
        if now >= info.end_time then
            CooldownRegistry:remove("player", id)
        end
    end

    for id, info in pairs(CooldownRegistry:get_all("global")) do
        if now >= info.end_time then
            CooldownRegistry:remove("global", id)
        end
    end
end

function m.clear_resource_cooldowns(resource)
    for id, info in pairs(CooldownRegistry:get_all("player")) do
        if info.resource == resource then
            CooldownRegistry:remove("player", id)
        end
    end

    for id, info in pairs(CooldownRegistry:get_all("global")) do
        if info.resource == resource then
            CooldownRegistry:remove("global", id)
        end
    end
end

--- @section Sweep

CreateThread(function()
    while true do
        Wait(30000)
        m.clear_all_cooldowns()
    end
end)

return m