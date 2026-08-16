--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/shared/globals/require.lua
--- @description Internal module and JSON loader.

--- @section Variables

local _cache = {}

--- @section Functions

local function safe_require(key)
    if not key or type(key) ~= "string" then return nil end

    local resource_name = GetCurrentResourceName()
    local path = key:gsub("%.lua$", ""):gsub("%.", "/") .. ".lua"
    local cache_key = ("%s:%s"):format(resource_name, path)

    if _cache[cache_key] then 
        print("debug", ("Loaded module from cache: %s"):format(path))
        return _cache[cache_key] 
    end

    local file_content = LoadResourceFile(resource_name, path)
    if not file_content then 
        print("warn", ("Module not found: %s"):format(path), true)
        return nil 
    end

    local env = setmetatable({}, { __index = _G })
    local chunk, err = load(file_content, ("@@%s/%s"):format(resource_name, path), "t", env)

    if not chunk then 
        print("error", ("Module compile error in %s: %s"):format(path, err), true)
        return nil 
    end

    local ok, res = pcall(chunk)
    if not ok then 
        print("error", ("Module runtime error in %s: %s"):format(path, res), true)
        return nil 
    end

    if type(res) ~= "table" then 
        print("error", ("Module %s did not return a table (got %s)"):format(path, type(res)), true)
        return nil 
    end

    _cache[cache_key] = res
    print("success", ("Successfully loaded module: %s"):format(path))
    return res
end

local function safe_require_json(key)
    if not key or type(key) ~= "string" then return nil end

    local resource_name = GetCurrentResourceName()
    local path = key:gsub("%.json$", ""):gsub("%.", "/") .. ".json"
    local cache_key = ("%s:%s"):format(resource_name, path)

    if _cache[cache_key] then 
        print("debug", ("Loaded JSON from cache: %s"):format(path))
        return _cache[cache_key] 
    end

    local file_content = LoadResourceFile(resource_name, path)
    if not file_content then 
        print("warn", ("JSON file not found: %s"):format(path), true)
        return nil 
    end

    local ok, res = pcall(json.decode, file_content)
    if not ok or not res then 
        print("error", ("Failed to parse JSON file %s"):format(path), true)
        return nil 
    end

    _cache[cache_key] = res
    print("success", ("Successfully loaded JSON: %s"):format(path))
    return res
end

--- @section Globals & Exports

_G.require = safe_require
_G.require_json = safe_require_json

exports("require", safe_require)
exports("require_json", safe_require_json)