--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/server/commands/exports.lua
--- @description Server side export registration for the command registry.

--- @section Imports

local commands = require("src.server.commands.functions")

--- @section Registration

local function register(opts)
    return commands.register(opts)
end
exports("register_command", register)

--- @section Suggestions

local function get_command_suggestions()
    return commands.get_command_suggestions()
end
exports("get_command_suggestions", get_command_suggestions)