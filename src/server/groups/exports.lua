--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/extensions/server/groups/exports.lua
--- @description Server side export registration for groups system.

--- @section Imports

local GroupRegistry = require("src.server.groups.registry")

--- @section Getters

local function get_group(name)
    return GroupRegistry:get_group(name)
end
exports("get_group", get_group)

local function get_member_groups(unique_id, char_id)
    return GroupRegistry:get_member_groups(unique_id, char_id)
end
exports("get_member_groups", get_member_groups)

local function get_member(unique_id, group_name, char_id)
    return GroupRegistry:get_member(unique_id, group_name, char_id)
end
exports("get_member", get_member)

--- @section Members

local function add_member(unique_id, group_name, role_name, char_id, opts)
    return GroupRegistry:add_member(unique_id, group_name, role_name, char_id, opts)
end
exports("add_member", add_member)

local function remove_member(unique_id, group_name, char_id)
    return GroupRegistry:remove_member(unique_id, group_name, char_id)
end
exports("remove_member", remove_member)

--- @section Permissions

local function has_permission(unique_id, permission, char_id)
    return GroupRegistry:has_permission(unique_id, permission, char_id)
end
exports("has_permission", has_permission)

local function can_manage(actor_unique_id, actor_char_id, target_unique_id, target_char_id, group_name)
    return GroupRegistry:can_manage(actor_unique_id, actor_char_id, target_unique_id, target_char_id, group_name)
end
exports("can_manage", can_manage)