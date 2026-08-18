--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/server/registry/player_registry.lua
--- @description Manages active in-game players, extensions, and routing.

--- @section Imports

local Registry = require("src.shared.classes.registry")
local RoutingBuckets = require("src.server.routing.class")
local Player = require("src.server.players.class")
local UserRegistry = require("src.server.users.registry")

--- @section Initialisation

local PlayerRegistry = {}
local _PlayerRegistry = Registry.new()

--- @section Methods

function PlayerRegistry:assign_personal_bucket(source, custom_config)
    return RoutingBuckets:assign_personal(source, custom_config)
end

function PlayerRegistry:set_bucket(source, bucket_key)
    return RoutingBuckets:set_player_bucket(source, bucket_key)
end

function PlayerRegistry:get_bucket(source)
    return RoutingBuckets:get_player_bucket(source)
end

function PlayerRegistry:register_extension(name, fn, priority)
    _PlayerRegistry:set("extensions", name, { name = name, fn = fn, priority = priority or 100 })
end

function PlayerRegistry:create(source, char_data)
    local user = UserRegistry:get(source)
    if not user then return nil end

    local p = Player.new(source, user, char_data)
    if not p then return nil end

    local ext_list = {}
    for _, ext in pairs(_PlayerRegistry:get_all("extensions")) do table.insert(ext_list, ext) end
    table.sort(ext_list, function(a, b) return a.priority < b.priority end)

    for _, ext in ipairs(ext_list) do
        local ok, err = pcall(ext.fn, p)
        if not ok then
            print("error", locale("server.players.extension_failed", ext.name, err))
        end
    end

    p:load()
    _PlayerRegistry:set("players", source, p)
    return p
end

function PlayerRegistry:get(source)
    return _PlayerRegistry:get("players", source)
end

function PlayerRegistry:get_all()
    return _PlayerRegistry:get_all("players")
end

function PlayerRegistry:remove(source)
    local p = _PlayerRegistry:get("players", source)
    if p then p:unload() end
    RoutingBuckets:release_personal(source, "main")
    _PlayerRegistry:remove("players", source)
end

function PlayerRegistry:save_all()
    for _, p in pairs(_PlayerRegistry:get_all("players")) do
        if getmetatable(p) then p:save() end
    end
end

return PlayerRegistry