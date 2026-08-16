--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @class Registry
--- @file src/server/classes/registry.lua
--- @description Generic registry class that holds many named collections of things.

--- @section Initialisation

local Registry = {}
Registry.__index = Registry

--- @section Helpers

local function get_table(self, bucket)
    if not self.items[bucket] then
        self.items[bucket] = {}
    end
    return self.items[bucket]
end

--- @section Factory

function Registry.new()
    return setmetatable({
        items = {}
    }, Registry)
end

--- @section Storage

function Registry:set(bucket, id, value)
    get_table(self, bucket)[id] = value
end

function Registry:remove(bucket, id)
    local t = self.items[bucket]
    if t then t[id] = nil end
end

function Registry:clear(bucket)
    self.items[bucket] = {}
end

--- @section Getters & Setters

function Registry:get(bucket, id)
    local t = self.items[bucket]
    return t and t[id]
end

function Registry:get_all(bucket)
    return self.items[bucket] or {}
end

function Registry:has(bucket, id)
    return self:get(bucket, id) ~= nil
end

function Registry:count(bucket)
    local n = 0
    for _ in pairs(self:get_all(bucket)) do n = n + 1 end
    return n
end

return Registry