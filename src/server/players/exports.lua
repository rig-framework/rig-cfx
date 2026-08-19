--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/server/players/exports.lua
--- @description Server side export registration for the Player class/registry.

--- @section Imports

local PlayerRegistry = require("src.server.players.registry")

--- @section Registry Level

local function create_player(source)
    return PlayerRegistry:create(source)
end
exports("create_player", create_player)

local function get_players()
    return PlayerRegistry:get_all()
end
exports("get_players", get_players)

local function get_player(source)
    return PlayerRegistry:get(source)
end
exports("get_player", get_player)

local function register_extension(name, fn, priority)
    return PlayerRegistry:register_extension(name, fn, priority)
end
exports("register_extension", register_extension)

local function assign_personal_bucket(source, custom_config)
    return PlayerRegistry:assign_personal_bucket(source, custom_config)
end
exports("assign_personal_bucket", assign_personal_bucket)

local function set_bucket(source, bucket_key)
    return PlayerRegistry:set_bucket(source, bucket_key)
end
exports("set_player_bucket", set_bucket)

local function get_bucket(source)
    return PlayerRegistry:get_bucket(source)
end
exports("get_player_bucket", get_bucket)

--- @section Instance Level

local function save_player(source)
    local p = PlayerRegistry:get(source)
    return p and p:save()
end
exports("save_player", save_player)

local function is_player_loaded(source)
    local p = PlayerRegistry:get(source)
    return p and p:has_loaded() or false
end
exports("is_player_loaded", is_player_loaded)

local function is_player_playing(source)
    local p = PlayerRegistry:get(source)
    return p and p:is_playing() or false
end
exports("is_player_playing", is_player_playing)

local function set_player_playing(source, state)
    local p = PlayerRegistry:get(source)
    if p then p:set_playing(state) end
end
exports("set_player_playing", set_player_playing)

--- @section Data

local function get_player_data(source, category)
    local p = PlayerRegistry:get(source)
    return p and p:get_data(category) or nil
end
exports("get_player_data", get_player_data)

local function has_player_data(source, category)
    local p = PlayerRegistry:get(source)
    return p and p:has_data(category) or false
end
exports("has_player_data", has_player_data)

local function remove_player_data(source, category)
    local p = PlayerRegistry:get(source)
    return p and p:remove_data(category) or false
end
exports("remove_player_data", remove_player_data)

local function sync_player_data(source, category)
    local p = PlayerRegistry:get(source)
    if p then p:sync(category) end
end
exports("sync_player_data", sync_player_data)

--- @section Methods

local function run_player_method(source, name, ...)
    local p = PlayerRegistry:get(source)
    return p and p:run_method(name, ...)
end
exports("run_player_method", run_player_method)

local function has_player_method(source, name)
    local p = PlayerRegistry:get(source)
    return p and p:has_method(name) or false
end
exports("has_player_method", has_player_method)

local function get_player_method(source, name)
    local p = PlayerRegistry:get(source)
    return p and p:get_method(name) or nil
end
exports("get_player_method", get_player_method)

--- @section Extensions

local function add_player_extension(source, name, ext)
    local p = PlayerRegistry:get(source)
    return p and p:add_extension(name, ext) or false
end
exports("add_player_extension", add_player_extension)

local function remove_player_extension(source, name)
    local p = PlayerRegistry:get(source)
    return p and p:remove_extension(name) or false
end
exports("remove_player_extension", remove_player_extension)

local function get_player_extension(source, name)
    local p = PlayerRegistry:get(source)
    return p and p:get_extension(name) or nil
end
exports("get_player_extension", get_player_extension)

local function has_player_extension(source, name)
    local p = PlayerRegistry:get(source)
    return p and p:has_extension(name) or false
end
exports("has_player_extension", has_player_extension)

local function list_player_extensions(source)
    local p = PlayerRegistry:get(source)
    return p and p:list_extensions() or {}
end
exports("list_player_extensions", list_player_extensions)