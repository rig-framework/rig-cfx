--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @class UserRegistry
--- @file src/server/classes/user_registry.lua
--- @description Manages account connections and the User class layer.

--- @section Constants

assert(rig and rig.settings, "rig.settings not initialised - check load order")

local CONNECTION_MESSAGES = rig.settings.connection_messages
local UNIQUE_ID_CHARS = rig.settings.unique_id_chars
local USERNAME_PREFIX = rig.settings.username_prefix

--- @section Imports

local Registry = require("src.shared.classes.registry")
local User = require("src.server.users.class")

local utils = require("src.server.utils")

--- @section Initialisation

local UserRegistry = {}
local _UserRegistry = Registry.new()

--- @section Helpers

local function update_deferral(deferrals, key, ...)
    if not CONNECTION_MESSAGES then return end
    local msg = locale(key, ...)
    deferrals.update(msg)
end

--- @section Persistence

function UserRegistry:exists(license)
    local query = "SELECT * FROM users WHERE license = ? LIMIT 1"
    return exports.oxmysql:query_async(query, { license })
end

function UserRegistry:persist(username, name, unique_id, license, discord, tokens, ip)
    local query = "INSERT INTO users (unique_id, username, name, license, discord, tokens, ip, metadata) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
    local params = { unique_id, username, name, license, discord, json.encode(tokens), ip, "{}" }
    return exports.oxmysql:insert_async(query, params)
end

--- @section Connections

function UserRegistry:request_connection(source, name, deferrals)
    local ids = utils.get_identifiers(source)
    if not ids.license then
        return deferrals.done(locale("server.users.no_license"))
    end

    deferrals.handover({
        name = GetPlayerName(source),
        res_name = GetCurrentResourceName()
    })
    
    deferrals.defer()
    update_deferral(deferrals, "core.server.users.checking")

    local result = self:exists(ids.license)
    local user_data = result and result[1]

    if not user_data then
        update_deferral(deferrals, "core.server.users.creating")
        local uid = utils.generate_unique_id(UNIQUE_ID_CHARS, "users", "unique_id", nil)
        local username = USERNAME_PREFIX .. "_" .. uid
        self:persist(username, name, uid, ids.license, ids.discord, GetPlayerTokens(source), ids.ip)
        user_data = { username = username, name = name, unique_id = uid, license = ids.license, discord = ids.discord, ip = ids.ip, banned = false }
    end

    update_deferral(deferrals, "core.server.users.checking_bans")
    local ban_query = "SELECT id, reason, expires_at FROM user_bans WHERE unique_id = ? AND expired = 0 ORDER BY created DESC LIMIT 1"
    local ban = exports.oxmysql:query_async(ban_query, { user_data.unique_id })
    local active_ban = ban and ban[1]

    if active_ban then
        if active_ban.expires_at and os.time() > (active_ban.expires_at / 1000) then
            exports.oxmysql:query_async("UPDATE user_bans SET expired = 1 WHERE id = ?", { active_ban.id })
            exports.oxmysql:query_async("UPDATE users SET banned = 0 WHERE unique_id = ?", { user_data.unique_id })
        else
            local time_str = active_ban.expires_at and os.date("%Y-%m-%d %H:%M:%S", active_ban.expires_at / 1000) or locale("server.users.ban_permanent")
            local reason = active_ban.reason or locale("server.users.ban_no_reason")
            return deferrals.done(locale("server.users.banned", time_str, reason))
        end
    end

    _UserRegistry:set("temp", ids.license, user_data)
    deferrals.done()
end

function UserRegistry:activate(source, license)
    local data = _UserRegistry:get("temp", license)
    if not data then return false end

    local u = User.new(source, data)
    _UserRegistry:set("active", source, u)
    _UserRegistry:remove("temp", license)
    return true
end

--- @section Active Users

function UserRegistry:get(source)
    return _UserRegistry:get("active", source)
end

function UserRegistry:remove(source)
    _UserRegistry:remove("active", source)
end

return UserRegistry