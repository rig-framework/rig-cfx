--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

fx_version "cerulean"
games { "gta5", "rdr3" }
name "rig"
version "0.1.0"
description "A fast, class-based OOP framework core built for CFX platforms (FiveM/RedM)."
license "Apache 2.0"
author "Case"
lua54 "yes"

ui_page "ui/index.html"

files {
    "locales/*.json",
    "ui/**/*",
}

shared_scripts {
    "init.lua",

    "src/shared/print.lua",
    "src/shared/require.lua",
    "src/shared/modules/*.lua",
    
    "src/shared/classes/*.lua",
    "src/shared/**/class.lua",

    "src/shared/**/registry.lua",
    "src/shared/**/functions.lua",
}

client_scripts {
    "src/client/**/class.lua",
    "src/client/**/registry.lua",
    "src/client/**/functions.lua",
    "src/client/**/events.lua",
    "src/client/**/nui_callbacks.lua",
    "src/client/**/exports.lua",

    "src/client/gameplay.lua",

    "tests/client/*.lua"
}

server_scripts {
    "src/server/**/class.lua",
    "src/server/**/registry.lua",
    "src/server/**/events.lua",
    "src/server/**/exports.lua",

    "src/server/utils.lua",

    "tests/server/*.lua"
}

dependency "oxmysql"
provide "rig"