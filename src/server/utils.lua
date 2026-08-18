--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @module utils
--- @file src/server/utils.lua
--- @description Handles all server side utility functions.

--- @section Initialisation

local m = {}

--- @section Player Functions

function m.get_identifiers(source)
    local ids = {}
    for _, id in ipairs(GetPlayerIdentifiers(source)) do
        if id:find("license") then ids.license = id end
        if id:find("discord") then ids.discord = id end
        if id:find("ip") then ids.ip = id end
    end
    return ids
end

--- @section Database Functions

function m.generate_unique_id(length, table_name, column, json_path)
    local charset = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local function create_id()
        local id = ""
        for i = 1, length do
            local idx = math.random(1, #charset)
            id = id .. charset:sub(idx, idx)
        end
        return id
    end
    local function id_exists(new_id)
        local query = json_path and string.format("SELECT COUNT(*) as count FROM %s WHERE JSON_EXTRACT(%s, '$.%s') = ?", table_name, column, json_path) or string.format("SELECT COUNT(*) as count FROM %s WHERE %s = ?", table_name, column)
        local result = exports.oxmysql:query_async(query, { new_id })
        return result and result[1] and result[1].count > 0
    end
    local id
    repeat id = create_id() until not id_exists(id)
    return id
end

return m