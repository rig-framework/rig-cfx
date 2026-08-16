local GroupRegistry = require("src.server.groups.init")
local UserRegistry = require("src.server.users.registry")

local function notify(source, msg)
    if source == 0 then
        print("[Group Test] " .. msg)
    else
        TriggerClientEvent("chat:addMessage", source, { args = { "^3[Group Test]", msg } })
    end
end

RegisterCommand("test_seed", function(source, args, rawCommand)
    notify(source, "Seeding test groups and roles into database...")

    exports.oxmysql:transaction_async({
        {
            query = "INSERT INTO groups (name, label, type, scope, parent_name, metadata) VALUES (?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE label = VALUES(label), type = VALUES(type), scope = VALUES(scope), parent_name = VALUES(parent_name)",
            values = { "admin", "Staff Team", "staff", "account", nil, json.encode({ color = "red" }) }
        },
        {
            query = "INSERT INTO groups (name, label, type, scope, parent_name, metadata) VALUES (?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE label = VALUES(label), type = VALUES(type), scope = VALUES(scope), parent_name = VALUES(parent_name)",
            values = { "syndicate", "The Criminal Syndicate", "alliance", "character", nil, json.encode({ alliance_vault = "vault_01" }) }
        },
        {
            query = "INSERT INTO groups (name, label, type, scope, parent_name, metadata) VALUES (?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE label = VALUES(label), type = VALUES(type), scope = VALUES(scope), parent_name = VALUES(parent_name)",
            values = { "ballas", "Ballas Street Gang", "gang", "character", "syndicate", json.encode({ turf = "Groove Street" }) }
        },
        {
            query = "INSERT INTO groups (name, label, type, scope, parent_name, metadata) VALUES (?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE label = VALUES(label), type = VALUES(type), scope = VALUES(scope), parent_name = VALUES(parent_name)",
            values = { "police", "Los Santos Police Dept", "job", "character", nil, json.encode({ station = "Mission Row" }) }
        },
        {
            query = "INSERT INTO group_roles (group_name, name, label, grade, permissions) VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE label = VALUES(label), permissions = VALUES(permissions)",
            values = { "admin", "owner", "Server Owner", 100, json.encode({ "*" }) }
        },
        {
            query = "INSERT INTO group_roles (group_name, name, label, grade, permissions) VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE label = VALUES(label), permissions = VALUES(permissions)",
            values = { "syndicate", "leader", "Alliance Leader", 10, json.encode({ "alliance.stash", "alliance.manage" }) }
        },
        {
            query = "INSERT INTO group_roles (group_name, name, label, grade, permissions) VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE label = VALUES(label), permissions = VALUES(permissions)",
            values = { "ballas", "boss", "Gang Boss", 5, json.encode({ "gang.stash", "gang.invite" }) }
        },
        {
            query = "INSERT INTO group_roles (group_name, name, label, grade, permissions) VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE label = VALUES(label), permissions = VALUES(permissions)",
            values = { "ballas", "prospect", "Prospect", 1, json.encode({ "gang.stash" }) }
        },
        {
            query = "INSERT INTO group_roles (group_name, name, label, grade, permissions) VALUES (?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE label = VALUES(label), permissions = VALUES(permissions)",
            values = { "police", "officer", "Police Officer", 1, json.encode({ "police.cuff", "police.jail" }) }
        }
    })

    GroupRegistry:load_all()
    notify(source, "^2Successfully seeded groups (admin, syndicate, ballas [child of syndicate], police).")
end, false)

RegisterCommand("test_join", function(source, args, rawCommand)
    if source == 0 then return print("Run this command in-game.") end

    local user = UserRegistry:get(source)
    if not user then return notify(source, "^1User session not found.") end

    GroupRegistry:add_member(user.unique_id, "admin", "owner", 0, { primary = false, metadata = { notes = "Account Staff Member" } })
    GroupRegistry:add_member(user.unique_id, "syndicate", "leader", 1, { primary = false, metadata = { notes = "Alliance Leader" } })
    GroupRegistry:add_member(user.unique_id, "ballas", "boss", 1, { primary = true, metadata = { nickname = "Big B" } })

    notify(source, ("^2Added %s to 'admin' (char 0), 'syndicate' (char 1), and 'ballas' (char 1)."):format(user.unique_id))
end, false)

RegisterCommand("test_info", function(source, args, rawCommand)
    if source == 0 then return print("Run this command in-game.") end

    local user = UserRegistry:get(source)
    if not user then return notify(source, "^1User session not found.") end

    local members = GroupRegistry:get_member_groups(user.unique_id, 1)
    if not members or #members == 0 then
        return notify(source, "^1You have no active memberships. Run /test_seed then /test_join first.")
    end

    notify(source, ("=== Group Hierarchy for %s ==="):format(user.unique_id))

    for _, m in ipairs(members) do
        local group = GroupRegistry:get_group(m.group_name)
        if group then
            local parent_info = ""
            if group.parent_name then
                local parent_group = GroupRegistry:get_group(group.parent_name)
                local parent_label = parent_group and parent_group.label or group.parent_name
                parent_info = (" ^5[Parent Alliance: %s (%s)]"):format(parent_label, group.parent_name)
            end

            notify(source, ("- Group: ^3%s^7 (%s) | Role: ^2%s^7 | Type: %s | CharID: %d%s"):format(
                group.label, group.name, m.role_name, group.type, m.char_id, parent_info
            ))
        end
    end
end, false)

RegisterCommand("test_perms", function(source, args, rawCommand)
    if source == 0 then return print("Run this command in-game.") end

    local user = UserRegistry:get(source)
    if not user then return notify(source, "^1User session not found.") end

    local checks = {
        { perm = "cmd.kick", char_id = 0, desc = "Wildcard '*' from admin (Account)" },
        { perm = "alliance.stash", char_id = 1, desc = "Explicit perm from syndicate (Alliance)" },
        { perm = "gang.stash", char_id = 1, desc = "Explicit perm from ballas (Gang)" },
        { perm = "police.cuff", char_id = 1, desc = "Unassigned police perm" }
    }

    notify(source, "=== Permission Check Tests ===")
    for _, test in ipairs(checks) do
        local has = GroupRegistry:has_permission(user.unique_id, test.perm, test.char_id)
        local status = has and "^2GRANTED^7" or "^1DENIED^7"
        notify(source, ("Node '%s' (char_id: %d) -> %s (%s)"):format(test.perm, test.char_id, status, test.desc))
    end
end, false)

RegisterCommand("test_rank", function(source, args, rawCommand)
    if source == 0 then return print("Run this command in-game.") end

    local user = UserRegistry:get(source)
    if not user then return notify(source, "^1User session not found.") end

    local dummy_id = "test_dummy_999"
    GroupRegistry:add_member(dummy_id, "ballas", "prospect", 1, { primary = false, metadata = {} })

    local can_manage_lower = GroupRegistry:can_manage(user.unique_id, 1, dummy_id, 1, "ballas")
    local lower_can_manage_boss = GroupRegistry:can_manage(dummy_id, 1, user.unique_id, 1, "ballas")
    local can_manage_self = GroupRegistry:can_manage(user.unique_id, 1, user.unique_id, 1, "ballas")

    notify(source, "=== Rank Comparison Tests (Ballas Gang) ===")
    
    local status1 = can_manage_lower and "^2PASS (true)^7" or "^1FAIL (false)^7"
    notify(source, ("Boss (Grade 5) manages Prospect (Grade 1): %s"):format(status1))
    
    local status2 = not lower_can_manage_boss and "^2PASS (false)^7" or "^1FAIL (true)^7"
    notify(source, ("Prospect (Grade 1) manages Boss (Grade 5): %s"):format(status2))
    
    local status3 = not can_manage_self and "^2PASS (false)^7" or "^1FAIL (true)^7"
    notify(source, ("Boss (Grade 5) manages Boss (Grade 5): %s"):format(status3))

    GroupRegistry:remove_member(dummy_id, "ballas", 1)
end, false)

RegisterCommand("test_leave", function(source, args, rawCommand)
    if source == 0 then return print("Run this command in-game.") end

    local user = UserRegistry:get(source)
    if not user then return notify(source, "^1User session not found.") end

    GroupRegistry:remove_member(user.unique_id, "admin", 0)
    GroupRegistry:remove_member(user.unique_id, "syndicate", 1)
    GroupRegistry:remove_member(user.unique_id, "ballas", 1)

    notify(source, "^2Removed yourself from all test groups.")
end, false)

RegisterCommand("test_wipe", function(source, args, rawCommand)
    exports.oxmysql:transaction_async({
        { query = "DELETE FROM group_members WHERE group_name IN ('admin', 'syndicate', 'ballas', 'police')", values = {} },
        { query = "DELETE FROM group_roles WHERE group_name IN ('admin', 'syndicate', 'ballas', 'police')", values = {} },
        { query = "DELETE FROM groups WHERE name IN ('admin', 'syndicate', 'ballas', 'police')", values = {} }
    })

    GroupRegistry:load_all()
    notify(source, "^2Wiped all test data from database and refreshed registry.")
end, false)