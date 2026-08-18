--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/server/gui/api.lua
--- @description Server side export registration for GUI bridge functions.

--- @section Imports

local gui = require("src.server.gui.functions")

--- @section Notify

local function notify(source, opts)
    return gui.notify(source, opts)
end
exports("notify", notify)

--- @section Modal

local function build_modal(source, opts)
    return gui.build_modal(source, opts)
end
exports("build_modal", build_modal)

local function close_modal(source, container)
    return gui.close_modal(source, container)
end
exports("close_modal", close_modal)

--- @section UI Framework

local function build_ui(source, ui)
    return gui.build_ui(source, ui)
end
exports("build_ui", build_ui)

local function close_ui(source)
    return gui.close_ui(source)
end
exports("close_ui", close_ui)