--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/core/shared/gui/registry.lua
--- @description Shared gui callback registration and lookup.

--- @section Imports

local Registry = require("src.core.shared.classes.registry")

--- @section Initialisation

local m = {}
local GUIFunctionRegistry = Registry.new()

--- @section Variables

local context = IsDuplicityVersion() and "server" or "client"

--- @section Functions

function m.has_function(label)
    return GUIFunctionRegistry:has(context, label)
end

function m.register_function(label, func)
    GUIFunctionRegistry:set(context, label, func)
end

function m.call_registered_function(label, data)
    if not label then
        print(("[rig:ui] function label is required"))
        return false
    end

    local func = GUIFunctionRegistry:get(context, label)
    if not func then
        print(("[rig:ui] function with label %s not found"):format(label))
        return false
    end

    return func(data)
end

return m