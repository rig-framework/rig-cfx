--[[
    User Registry Test
    -------------------------------

    This one just tests out the user side before you ever touch a player object.
    Users and players are two different things in rig, a user is just the account tied to a license.
    A player is the in-game avatar/character/player sitting on top of it.
    You need a user before you can create a player, thats why this runs first.

    Run the command below and check the ingame chat for outputs.

    -- Command

    Run `/test_auth` to authenticate/activate your user account
]]

--- @section Imports
--- Require the classes/modules you need into the file using the global `require()` function.

local UserRegistry = require("src.core.server.users.registry")
local utils = require("src.core.server.utils")

--- @section Helpers
--- Just a helper function to send chat messages this is not important.

local function notify(source, msg)
    if source == 0 then
        print("[Auth Test] " .. msg)
    else
        TriggerClientEvent("chat:addMessage", source, { args = { "^3[Auth Test]", msg } })
    end
end

--- @section Commands
--[[
    /test_auth pulls your license off your identifiers, registers you as a
    pending connection, then activates the user. Activate is what actually
    creates/loads the account row, request_connection on its own doesnt.
]]

RegisterCommand("test_auth", function(source, args, rawCommand)
    if source == 0 then return print("Run this command in-game.") end
 
    local ids = utils.get_identifiers(source)
 
    if not ids.license then
        return notify(source, "^1No license found for your player.")
    end
 
    -- deferrals are normally used to hold the player on the loading screen while checks run
    -- since not needed for this test they stubbed out
    local dummy_deferrals = {
        defer = function() end,
        update = function() end,
        done = function() end,
        handover = function() end
    }
 
    UserRegistry:request_connection(source, GetPlayerName(source), dummy_deferrals)
 
    if UserRegistry:activate(source, ids.license) then
        local user = UserRegistry:get(source)
        notify(source, ("^2User account authenticated: %s (%s)"):format(user.username, user.unique_id))
    else
        notify(source, "^1Failed to activate user account.")
    end
end, false)