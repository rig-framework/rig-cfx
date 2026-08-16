--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @class Player
--- @file src/client/classes/player.lua
--- @description Client side player class, just a data store nothing fancy.

--- @section Initialisation

local Player = {}
Player.__index = Player

local listeners = {}

local self_instance = setmetatable({
    data = {},
    playing = false
}, Player)

--- @section Events

function Player:emit(event, ...)
    local handlers = listeners[event]
    if not handlers then return end

    for i = 1, #handlers do
        pcall(handlers[i], self, ...)
    end

    TriggerEvent(("rig:client:player_%s"):format(event), ...)
end

function Player:on(event, fn)
    listeners[event] = listeners[event] or {}
    listeners[event][#listeners[event] + 1] = fn
end

--- @section State

function Player:is_playing()
    return self.playing == true
end

function Player:set_playing(state)
    self.playing = state == true
    self:emit("playing_changed", self.playing)
end

--- @section Data

function Player:get_data(category)
    return category and self.data[category] or self.data
end

function Player:has_data(category)
    return self.data[category] ~= nil
end

function Player:set_data(category, data)
    if type(category) ~= "string" or type(data) ~= "table" then return false end
    self.data[category] = data
    self:emit("data_synced", category, data)
    return true
end

function Player:sync(payload)
    if type(payload) ~= "table" then return end
    for category, data in pairs(payload) do
        if type(category) == "string" and type(data) == "table" then
            self:set_data(category, data)
        end
    end
end

function Player:dump()
    print("debug", locale("core.client.players.data_dump", json.encode(self.data)))
end

return self_instance