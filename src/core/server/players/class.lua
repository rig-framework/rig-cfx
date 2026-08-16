--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @class Player
--- @file src/server/classes/player.lua
--- @description The main Character/Player class for RIG.

--- @section Initialisation

local Player = {}
Player.__index = Player
Player.__metatable = false

local private = {}
local listeners = {}

--- @section Functions

local function priv_of(self)
    return private[self]
end

--- @section Factory

function Player.new(source, user, char_data)
    if not source or not user or not char_data then return nil end
    local self = setmetatable({
        source = source,
        user_id = user.user_id,
        char_id = char_data.char_id,
    }, Player)

    private[self] = {
        data = {
            flags = { loaded = false, playing = false },
        },
        replicated = {},
        extensions = {},
        methods = {},
        listeners = {}
    }
    return self
end

--- @section Event Bus

function Player:on(event, handler)
    local priv = priv_of(self)
    if not priv or type(event) ~= "string" or type(handler) ~= "function" then return false end
    priv.listeners[event] = priv.listeners[event] or {}
    local handlers = priv.listeners[event]
    handlers[#handlers + 1] = handler
    return true
end

function Player:off(event, handler)
    local priv = priv_of(self)
    local handlers = priv and priv.listeners[event]
    if not handlers then return false end
    for i = #handlers, 1, -1 do
        if handlers[i] == handler then
            table.remove(handlers, i)
            return true
        end
    end
    return false
end

function Player:emit(event, ...)
    local priv = priv_of(self)
    if not priv then return end

    local handlers = priv.listeners[event]
    if handlers then
        for i = 1, #handlers do
            pcall(handlers[i], self, ...)
        end
    end

    TriggerEvent(("rig:server:player_%s"):format(event), self.source, ...)
end

--- @section Lifecycle

function Player:load()
    local priv = priv_of(self)
    if not priv then return false end

    for name, ext in pairs(priv.extensions) do
        if ext.on_load then
            local ok, err = pcall(ext.on_load, ext)
            if not ok then self:emit("extension_error", name, "on_load", err) end
        end
    end

    self:sync()
    self:set_data("flags", { loaded = true })
    self:emit("loaded")
    return true
end

function Player:save()
    local priv = priv_of(self)
    if not priv or not priv.data.flags.playing then return false end

    local queries = {}
    for name, ext in pairs(priv.extensions) do
        if ext.on_save then
            local ok, res = pcall(ext.on_save, ext)
            if ok and res then
                for _, q in ipairs(res) do queries[#queries + 1] = q end
            elseif not ok then
                self:emit("extension_error", name, "on_save", res)
            end
        end
    end

    self:emit("before_save", queries)
    if #queries > 0 then exports.oxmysql:transaction_async(queries) end
    self:emit("saved")
    return true
end

function Player:unload()
    local priv = priv_of(self)
    if not priv then return false end
    for name, ext in pairs(priv.extensions) do
        if ext.on_unload then
            local ok, err = pcall(ext.on_unload, ext)
            if not ok then self:emit("extension_error", name, "on_unload", err) end
        end
    end
    self:emit("unloaded")
    private[self] = nil
    return true
end

--- @section State

function Player:has_loaded()
    local priv = priv_of(self)
    return priv ~= nil and priv.data.flags.loaded == true
end

function Player:is_playing()
    local priv = priv_of(self)
    return priv ~= nil and priv.data.flags.playing == true
end

function Player:set_playing(state)
    local priv = priv_of(self)
    if not priv then return end
    priv.data.flags.playing = state
    TriggerClientEvent("rig:client:playing_state_changed", self.source, state)
    self:emit("playing_changed", state)
end

--- @section Data

function Player:add_data(category, value, replicate)
    local priv = priv_of(self)
    if not priv then return false end
    priv.data[category] = value
    if replicate then priv.replicated[category] = true end
    self:emit("data_added", category, value, replicate)
    return true
end

function Player:get_data(category)
    local priv = priv_of(self)
    return priv and (category and priv.data[category] or priv.data)
end

function Player:has_data(category)
    local priv = priv_of(self)
    return priv ~= nil and priv.data[category] ~= nil
end

function Player:set_data(category, updates, sync)
    local priv = priv_of(self)
    if not priv then return false end
    local target = priv.data[category]
    if type(target) == "table" and type(updates) == "table" then
        for k, v in pairs(updates) do target[k] = v end
        if sync then self:sync(category) end
        self:emit("data_changed", category, updates)
    end
    return true
end

function Player:replace_data(category, data, sync)
    local priv = priv_of(self)
    if not priv or priv.data[category] == nil then return false end
    priv.data[category] = type(data) == "table" and data or {}
    if sync then self:sync(category) end
    self:emit("data_replaced", category, data)
    return true
end

function Player:remove_data(category)
    local priv = priv_of(self)
    if not priv or priv.data[category] == nil then return false end
    priv.data[category] = nil
    self:sync(category)
    self:emit("data_removed", category)
    return true
end

function Player:sync(category)
    local priv = priv_of(self)
    if not priv then return end
    local payload = {}
    if category then
        if priv.replicated[category] then payload[category] = priv.data[category] end
    else
        for k in pairs(priv.replicated) do payload[k] = priv.data[k] end
    end
    TriggerClientEvent("rig:client:sync_player_data", self.source, payload)
    self:emit("synced", payload)
end

--- @section Methods

function Player:add_method(name, fn)
    local priv = priv_of(self)
    if not priv or type(name) ~= "string" or type(fn) ~= "function" then return false end
    priv.methods[name] = fn
    self:emit("method_added", name)
    return true
end

function Player:remove_method(name)
    local priv = priv_of(self)
    if not priv or not priv.methods[name] then return false end
    priv.methods[name] = nil
    self:emit("method_removed", name)
    return true
end

function Player:run_method(name, ...)
    local priv = priv_of(self)
    local fn = priv and priv.methods[name]
    if not fn then return nil end
    return fn(...)
end

function Player:has_method(name)
    local priv = priv_of(self)
    return priv ~= nil and priv.methods[name] ~= nil
end

function Player:get_method(name)
    local priv = priv_of(self)
    return priv and priv.methods[name]
end

--- @section Extensions

function Player:add_extension(name, ext)
    local priv = priv_of(self)
    if not priv or type(name) ~= "string" or type(ext) ~= "table" then return false end
    priv.extensions[name] = ext
    self:emit("extension_added", name, ext)
    return true
end

function Player:remove_extension(name)
    local priv = priv_of(self)
    if not priv or not priv.extensions[name] then return false end
    priv.extensions[name] = nil
    self:emit("extension_removed", name)
    return true
end

function Player:get_extension(name)
    local priv = priv_of(self)
    return priv and priv.extensions[name]
end

function Player:has_extension(name)
    local priv = priv_of(self)
    return priv ~= nil and priv.extensions[name] ~= nil
end

function Player:list_extensions()
    local priv = priv_of(self)
    local keys = {}
    if not priv then return keys end
    for k in pairs(priv.extensions) do keys[#keys + 1] = k end
    return keys
end

return Player