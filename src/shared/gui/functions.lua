--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/shared/gui/functions.lua
--- @description Shared gui functions

--- @section Imports

local registry = require("src.shared.gui.registry")

--- @section Initialisation

local m = {}

--- @section Functions

function m.sanitize(data, path)
    path = path or "root"
    local out = {}

    for k, v in pairs(data) do
        local p = ("%s_%s"):format(path, tostring(k)):gsub("[^%w_]", "")

        if (k == "on_action" or k == "on_increment" or k == "on_decrement" or k == "on_select") then
            registry.register_function(p, v)
            out.action = p
        elseif type(v) == "table" then
            out[k] = m.sanitize(v, p)
        else
            out[k] = v
        end
    end

    return out
end

return m