--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/server/users/exports.lua
--- @description Server side export registration for user accounts.

--- @section Imports

local UserRegistry = require("src.server.users.registry")

--- @section Functions

local function get_user(source)
    return UserRegistry:get(source)
end
exports("get_user", get_user)