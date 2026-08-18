--[[
    Player Object & Extension Tests
    -------------------------------

    Player cores in rig work a little different to normal frameworks.
    Everything is built to be extended, the core doesnt care what data its handling it just handles it.

    This is a really simple example of how building player extensions works internally.

    Run the commands in the order below and check the ingame chat for outputs.
    
    -- Command Order

    1. Run `/test_auth` from tests/server/users.lua if you dont have a user account
    2. Run `/test_player` to create test player object
    3. Then `/test_dump` to print data added from tests/extensions/player_ext.lua
    4. Then `/test_deplete` to force "hunger" to 0 firing the event bus from tests/extensions/player_reactor_ext.lua
    5. Finally run `/test_dump` again to check it all worked :)  
]]

--- @section Imports
--- Require the classes/modules you need into the file using the global `require()` function.

local PlayerRegistry = require("src.server.players.registry")
local TestExtension = require("tests.server.player_ext")
local TestReactorExtension = require("tests.server.player_reactor_ext")

--- @section Helpers
--- Just a helper function to send chat messages this is not important. 

local function notify(source, msg)
    if source == 0 then
        print("[Player Test] " .. msg)
    else
        TriggerClientEvent("chat:addMessage", source, { args = { "^3[Player Test]", msg } })
    end
end

--- @section Registering Extensions
--- RIG uses a "extension" system for building player objects.
--- You can extend it with anything you want and everything is handled through the same API set.
--- A extension is basically just a table of data/functions attached to a player, its not anyway near as complicated as it sounds.

PlayerRegistry:register_extension("test_extension", function(player)
    player:add_extension("test_extension", setmetatable({ player = player }, { __index = TestExtension }))
end)

PlayerRegistry:register_extension("test_reactor_extension", function(player)
    player:add_extension("test_reactor_extension", setmetatable({ player = player }, { __index = TestReactorExtension }))
end)

--- @section Commands
--- See command order in the header above.

RegisterCommand("test_player", function(source)
    if source == 0 then return print("Run this command in-game.") end

    local char_data = { char_id = 1 }

    local player = PlayerRegistry:create(source, char_data)
    if player then
        notify(source, "^2Player created and loaded.")
    else
        notify(source, "^1Failed to create player - did you run test_user first?")
    end
end, false)

RegisterCommand("test_dump", function(source)
    if source == 0 then return print("Run this command in-game.") end

    local player = PlayerRegistry:get(source)
    if not player then return notify(source, "^1No player found - run test_player first.") end

    notify(source, "loaded=" .. tostring(player:has_loaded()) .. " playing=" .. tostring(player:is_playing()))

    local stats = player:get_data("test_stats")
    notify(source, ("test_stats before: hunger=%s thirst=%s"):format(stats.hunger, stats.thirst))

    player:run_method("adjust_test_stat", "hunger", -25)

    stats = player:get_data("test_stats")
    notify(source, ("test_stats after adjust: hunger=%s thirst=%s"):format(stats.hunger, stats.thirst))
end, false)

RegisterCommand("test_deplete", function(source)
    if source == 0 then return print("Run this command in-game.") end

    local player = PlayerRegistry:get(source)
    if not player then return notify(source, "^1No player found - run test_player first.") end

    player:run_method("adjust_test_stat", "hunger", -100)

    local reactor = player:get_data("test_reactor")
    notify(source, ("reactor state: triggered_by=%s count=%s"):format(tostring(reactor.triggered_by), reactor.count))
end, false)