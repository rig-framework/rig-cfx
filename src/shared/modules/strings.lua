--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @module strings
--- @file src/shared/modules/strings.lua
--- @description Extra string utilities beyond standard Lua string library

--- @section Initialisation

local m = {}

--- @section Functions

function m.split(str, delimiter)
    if type(str) ~= "string" then
        error("split: expected string, got " .. type(str))
    end
    if type(delimiter) ~= "string" or delimiter == "" then
        error("split: delimiter must be non-empty string")
    end

    local result = {}
    for piece in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, piece)
    end
    return result
end

function m.trim(str)
    if type(str) ~= "string" then
        error("trim: expected string, got " .. type(str))
    end
    return str:match("^%s*(.-)%s*$") or ""
end

function m.starts_with(str, prefix)
    if type(str) ~= "string" or type(prefix) ~= "string" then
        error("starts_with: expected strings")
    end
    return str:sub(1, #prefix) == prefix
end

function m.ends_with(str, suffix)
    if type(str) ~= "string" or type(suffix) ~= "string" then
        error("ends_with: expected strings")
    end
    return str:sub(-#suffix) == suffix
end

function m.is_empty(str)
    if type(str) ~= "string" then
        error("is_empty: expected string, got " .. type(str))
    end
    return m.trim(str) == ""
end

function m.lowercase(str)
    if type(str) ~= "string" then
        error("lowercase: expected string, got " .. type(str))
    end
    return str:lower()
end

function m.uppercase(str)
    if type(str) ~= "string" then
        error("uppercase: expected string, got " .. type(str))
    end
    return str:upper()
end

function m.capitalize(str)
    if type(str) ~= "string" then
        error("capitalize: expected string, got " .. type(str))
    end
    return string.gsub(str, "(%a)([%w_']*)", function(first, rest)
        return first:upper() .. rest:lower()
    end)
end

function m.contains(str, substring)
    if type(str) ~= "string" or type(substring) ~= "string" then
        error("contains: expected strings")
    end
    return str:find(substring, 1, true) ~= nil
end

return m