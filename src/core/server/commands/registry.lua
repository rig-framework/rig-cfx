--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/server/commands/registry.lua
--- @description ACE permission-based command registration + chat suggestion storage.

--- @section Imports

local Registry = require("src.core.shared.classes.registry")

--- @section Initialisation

local m = {}
local _CommandRegistry = Registry.new()

--- @section Constants

local DEV_MODE = GetConvar("commands:dev_mode", "false") == "true"

--- @section Permissions

local function has_permission(source, required_ace)
    if DEV_MODE then return true end
    if not required_ace then return true end

    local aces = type(required_ace) == "table" and required_ace or { required_ace }

    for _, ace in ipairs(aces) do
        if IsPlayerAceAllowed(source, ace) then
            return true
        end
    end

    return false
end

--- @section Registration

--- Registers a command with ACE permission checks.
--- @param opts table: { name, ace, help, params, handler }
function m.register(opts)
    if not opts or not opts.name or not opts.handler then
        print("[commands] Registration failed: missing name or handler")
        return false
    end

    if opts.help and opts.params then
        _CommandRegistry:set("suggestions", opts.name, { help = opts.help, params = opts.params })
    end

    RegisterCommand(opts.name, function(source, args, raw)
        if has_permission(source, opts.ace) then
            opts.handler(source, args, raw)
        else
            TriggerClientEvent("chat:addMessage", source, {
                args = { "^1PERMISSION DENIED", "You don't have permission to use this command." }
            })
        end
    end, false)

    return true
end

--- @section Suggestions

--- Returns all registered suggestions formatted for chat:addSuggestions.
function m.get_formatted_suggestions()
    local formatted = {}
    for name, suggestion in pairs(_CommandRegistry:get_all("suggestions")) do
        formatted[#formatted + 1] = {
            name = "/" .. name,
            help = suggestion.help,
            params = suggestion.params
        }
    end
    return formatted
end

return m