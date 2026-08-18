--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/server/cooldowns/exports.lua
--- @description Server side export registration for cooldowns.

--- @section Imports

local cooldowns = require("src.server.cooldowns.functions")

--- @section Exports

local function add_cooldown(source, cooldown_type, duration, is_global)
    return cooldowns.add_cooldown(source, cooldown_type, duration, is_global)
end
exports("add_cooldown", add_cooldown)

local function check_cooldown(source, cooldown_type, is_global)
    return cooldowns.check_cooldown(source, cooldown_type, is_global)
end
exports("check_cooldown", check_cooldown)

local function clear_cooldown(source, cooldown_type, is_global)
    return cooldowns.clear_cooldown(source, cooldown_type, is_global)
end
exports("clear_cooldown", clear_cooldown)

local function clear_resource_cooldowns(resource)
    return cooldowns.clear_resource_cooldowns(resource)
end
exports("clear_resource_cooldowns", clear_resource_cooldowns)