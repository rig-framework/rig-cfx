--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/client/players/api.lua
--- @description Client side export registration for reading replicated player data.

--- @section Imports

local player = require("src.client.players.class")
local player_fns = require("src.client.players.functions")

--- @section Player Data

local function get_player_data(category)
    return player:get_data(category)
end
exports("get_player_data", get_player_data)

local function has_player_data(category)
    return player:has_data(category)
end
exports("has_player_data", has_player_data)

local function is_player_playing()
    return player:is_playing()
end
exports("is_player_playing", is_player_playing)
 
--- @section Utilities

local function get_player_headshot()
    return player_fns.get_player_headshot()
end
exports("get_player_headshot", get_player_headshot)