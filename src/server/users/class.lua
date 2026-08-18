--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @class User
--- @file src/server/classes/user.lua
--- @description The main Account/User class for RIG.

--- @section Initialisation

local User = {}
User.__index = User
User.__metatable = false

local private = {}
local listeners = {}

--- @section Functions

local function priv_of(self)
    return private[self]
end

--- @section Factory

function User.new(source, data)
    if not source or not data then return nil end
    local self = setmetatable({
        source = source,
        unique_id = data.unique_id,
        license = data.license,
        username = data.username,
        name = data.name,
    }, User)

    private[self] = {
        banned = data.banned == 1 or data.banned == true,
        muted = data.muted == 1 or data.muted == true,
        metadata = data.metadata or {}
    }
    return self
end

--- @section Event Bus

function User:emit(event, ...)
    local handlers = listeners[event]
    if not handlers then return end

    for i = 1, #handlers do
        pcall(handlers[i], self, ...)
    end

    TriggerEvent(("rig:server:user_%s"):format(event), self.source, ...)
end

--- @section Moderation

function User:is_banned()
    local priv = priv_of(self)
    return priv ~= nil and priv.banned == true
end

function User:is_muted()
    local priv = priv_of(self)
    return priv ~= nil and priv.muted == true
end

function User:ban(banned_by, reason, expires_at)
    local priv = priv_of(self)
    if not priv then return false end

    exports.oxmysql:transaction_async({
        { query = "UPDATE users SET banned = 1 WHERE unique_id = ?", values = { self.unique_id } },
        { query = "INSERT INTO user_bans (unique_id, banned_by, reason, expires_at) VALUES (?, ?, ?, ?)", values = { self.unique_id, banned_by or "rig", reason or nil, expires_at or nil } }
    })
    priv.banned = true
    self:emit("banned", banned_by, reason, expires_at)
    DropPlayer(self.source, reason or "You have been banned.")
end

function User:unban(appealed_by)
    local priv = priv_of(self)
    if not priv then return false end

    exports.oxmysql:transaction_async({
        { query = "UPDATE users SET banned = 0 WHERE unique_id = ?", values = { self.unique_id } },
        { query = "UPDATE user_bans SET expired = 1, appealed = 1, appealed_by = ? WHERE unique_id = ? AND expired = 0", values = { appealed_by or "rig", self.unique_id } }
    })
    priv.banned = false
    self:emit("unbanned", appealed_by)
end

function User:warn(warned_by, reason)
    local priv = priv_of(self)
    if not priv then return false end

    exports.oxmysql:insert_async("INSERT INTO user_warnings (unique_id, warned_by, reason) VALUES (?, ?, ?)", { self.unique_id, warned_by or "rig", reason or nil })
    TriggerClientEvent("rig:client:user_warned", self.source, warned_by, reason)
    self:emit("warned", warned_by, reason)
end

function User:get_bans()
    return exports.oxmysql:query_async("SELECT * FROM user_bans WHERE unique_id = ? ORDER BY created DESC", { self.unique_id })
end

function User:get_warnings()
    return exports.oxmysql:query_async("SELECT * FROM user_warnings WHERE unique_id = ? ORDER BY created DESC", { self.unique_id })
end

function User:get_active_ban()
    local result = exports.oxmysql:query_async("SELECT * FROM user_bans WHERE unique_id = ? AND expired = 0 ORDER BY created DESC LIMIT 1", { self.unique_id })
    return result and result[1] or nil
end

function User:mute(muted_by, reason)
    local priv = priv_of(self)
    if not priv then return false end
    exports.oxmysql:update_async("UPDATE users SET muted = 1 WHERE unique_id = ?", { self.unique_id })
    priv.muted = true
    self:emit("muted", muted_by, reason)
end

function User:unmute()
    local priv = priv_of(self)
    if not priv then return false end
    exports.oxmysql:update_async("UPDATE users SET muted = 0 WHERE unique_id = ?", { self.unique_id })
    priv.muted = false
    self:emit("unmuted")
end

return User