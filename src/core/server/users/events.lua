--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/server/events/user.lua
--- @description Handles server-side user connections, registry handles everything else.

--- @section Imports

local UserRegistry = require("src.core.server.users.registry")

--- @section Event Handlers

AddEventHandler("playerConnecting", function(name, kick, deferrals)
    UserRegistry:request_connection(source, name, deferrals)
end)