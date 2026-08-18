--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/client/gui/exports.lua
--- @description Client side export registration for GUI functions.

--- @section Imports

local gui = require("src.client.gui.functions")

--- @section Notify

local function notify(opts)
    return gui.notify(opts)
end
exports("notify", notify)

--- @section Modal

local function build_modal(opts)
    return gui.build_modal(opts)
end
exports("build_modal", build_modal)

local function close_modal(container)
    return gui.close_modal(container)
end
exports("close_modal", close_modal)

--- @section UI Framework

local function build_ui(ui)
    return gui.build_ui(ui)
end
exports("build_ui", build_ui)

local function close_ui()
    return gui.close_ui()
end
exports("close_ui", close_ui)