--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/server/routing/exports.lua
--- @description Server side export registration for RoutingBuckets.

--- @section Imports

local RoutingBuckets = require("src.server.routing.class")

--- @section Buckets

local function register_bucket(key, config)
    return RoutingBuckets:register(key, config)
end
exports("register_bucket", register_bucket)

--- @section Players

local function set_player_bucket(source, target_key)
    return RoutingBuckets:set_player_bucket(source, target_key)
end
exports("set_player_bucket", set_player_bucket)

local function get_player_bucket(source)
    return RoutingBuckets:get_player_bucket(source)
end
exports("get_player_bucket", get_player_bucket)

--- @section Personal Buckets

local function assign_personal_bucket(source, custom_config)
    return RoutingBuckets:assign_personal(source, custom_config)
end
exports("assign_personal_bucket", assign_personal_bucket)

local function release_personal_bucket(source, fallback_key)
    return RoutingBuckets:release_personal(source, fallback_key)
end
exports("release_personal_bucket", release_personal_bucket)