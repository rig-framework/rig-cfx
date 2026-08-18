--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/server/commands/functions.lua
--- @description ACE permission-based command registration + chat suggestion storage.

--- @section Imports

local CommandRegistry = require("src.server.commands.registry")

--- @section Initialisation

local m = {}

--- @section Permissions

function m.has_permission(source, required_ace)
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

function m.register(opts)
    if not opts or not opts.name or not opts.handler then
        print("error", locale("server.commands.registration_failed"))
        return false
    end

    if opts.help and opts.params then
        CommandRegistry:set("suggestions", opts.name, { help = opts.help, params = opts.params })
    end

    RegisterCommand(opts.name, function(source, args, raw)
        if m.has_permission(source, opts.ace) then
            opts.handler(source, args, raw)
        else
            TriggerClientEvent("chat:addMessage", source, {
                args = { locale("server.commands.permission_denied_title"), locale("server.commands.permission_denied_desc") }
            })
        end
    end, false)

    return true
end

--- @section Suggestions

function m.get_command_suggestions()
    local formatted = {}
    for name, suggestion in pairs(CommandRegistry:get_all("suggestions")) do
        formatted[#formatted + 1] = {
            name = "/" .. name,
            help = suggestion.help,
            params = suggestion.params
        }
    end
    return formatted
end

return m