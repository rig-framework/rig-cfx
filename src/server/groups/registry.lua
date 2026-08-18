--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @class GroupRegistry
--- @file src/extensions/server/groups/registry.lua
--- @description Loads and manages groups, roles, and members for RIG.

--- @section Imports

local Registry = require("src.shared.classes.registry")
local Group = require("src.server.groups.class")

--- @section Initialisation

local GroupRegistry = {}
local _GroupRegistry = Registry.new()

--- @section Internal Functions

local function check_group_permission(group, role_name, permission)
    if group:has_permission(role_name, permission) then return true end

    if group.metadata.inherit_permissions and group.parent_name then
        local parent = GroupRegistry:get_group(group.parent_name)
        if parent and parent.roles[role_name] then
            return check_group_permission(parent, role_name, permission)
        end
    end

    return false
end

--- @section Lifecycle Methods

function GroupRegistry:load_all()
    _GroupRegistry:clear("groups")

    local groups = exports.oxmysql:query_async("SELECT * FROM groups", {})
    if not groups then return end

    for _, g in ipairs(groups) do
        local group_obj = Group.new(g)
        local roles = exports.oxmysql:query_async("SELECT * FROM group_roles WHERE group_name = ?", { g.name })

        if roles then
            for _, r in ipairs(roles) do
                group_obj:add_role(r)
            end
        end

        _GroupRegistry:set("groups", g.name, group_obj)
    end
end

--- @section Getter Methods

function GroupRegistry:get_group(name)
    return _GroupRegistry:get("groups", name)
end

function GroupRegistry:get_member_groups(unique_id, char_id)
    char_id = char_id or 0
    local query = "SELECT * FROM group_members WHERE unique_id = ? AND (char_id = ? OR char_id = 0)"
    return exports.oxmysql:query_async(query, { unique_id, char_id })
end

function GroupRegistry:get_member(unique_id, group_name, char_id)
    char_id = char_id or 0
    local query = "SELECT * FROM group_members WHERE unique_id = ? AND group_name = ? AND (char_id = ? OR char_id = 0) LIMIT 1"
    local result = exports.oxmysql:query_async(query, { unique_id, group_name, char_id })
    return result and result[1]
end

--- @section Member Methods

function GroupRegistry:add_member(unique_id, group_name, role_name, char_id, opts)
    opts = opts or {}

    local group = self:get_group(group_name)
    if not group then
        return false, "group_not_found"
    end

    if group.scope == "account" then
        char_id = 0
    else
        if not char_id or char_id == 0 then
            return false, "char_id_required"
        end
    end

    local query = "INSERT INTO group_members (group_name, unique_id, char_id, role_name, is_primary, metadata) VALUES (?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE role_name = VALUES(role_name), is_primary = VALUES(is_primary), metadata = VALUES(metadata)"
    local affected = exports.oxmysql:insert_async(query, {
        group_name, unique_id, char_id, role_name,
        opts.primary and 1 or 0,
        json.encode(opts.metadata or {})
    })

    return affected > 0
end

function GroupRegistry:remove_member(unique_id, group_name, char_id)
    local group = self:get_group(group_name)
    if not group then return false, "group_not_found" end

    char_id = group.scope == "account" and 0 or (char_id or 0)

    local affected = exports.oxmysql:update_async("DELETE FROM group_members WHERE group_name = ? AND unique_id = ? AND char_id = ?", { group_name, unique_id, char_id })
    return affected > 0
end

--- @section Permissions

function GroupRegistry:has_permission(unique_id, permission, char_id)
    local members = self:get_member_groups(unique_id, char_id)
    if not members then return false end

    for _, member in ipairs(members) do
        local group = self:get_group(member.group_name)
        if group and check_group_permission(group, member.role_name, permission) then
            return true
        end
    end

    return false
end

function GroupRegistry:can_manage(actor_unique_id, actor_char_id, target_unique_id, target_char_id, group_name)
    local group = self:get_group(group_name)
    if not group then return false end

    local actor = self:get_member(actor_unique_id, group_name, actor_char_id)
    local target = self:get_member(target_unique_id, group_name, target_char_id)
    if not actor or not target then return false end

    return group:role_outranks(actor.role_name, target.role_name)
end

return GroupRegistry