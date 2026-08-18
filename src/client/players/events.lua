--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/client/events.lua
--- @description Client side player events.

local player = require("src.client.players.class")

--- @section Class Event Listeners

player:on("data_synced", function(self, category, data)
    print("debug", locale("client.players.data_synced", category, json.encode(data)))
end)

--- @section Network Events

RegisterNetEvent("rig:client:player_loaded")
AddEventHandler("rig:client:player_loaded", function(meta)
    if type(meta) ~= "table" or not meta.source then 
        print("error", locale("client.players.meta_missing")) 
        return 
    end
    
    print("info", locale("client.players.loaded", meta.username, meta.source))
end)

RegisterNetEvent("rig:client:playing_state_changed")
AddEventHandler("rig:client:playing_state_changed", function(state)
    if state == nil then 
        print("error", locale("client.players.playing_state_missing")) 
        return 
    end
    
    player:set_playing(state)
    print("info", locale("client.players.playing_state_changed", player:is_playing() and "playing" or "not playing"))
end)

RegisterNetEvent("rig:client:sync_player_data")
AddEventHandler("rig:client:sync_player_data", function(payload)
    if type(payload) ~= "table" then return end
    player:sync(payload)
end)