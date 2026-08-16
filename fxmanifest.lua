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

ui_page "ui/core/index.html"

files {
    "locales/*.json",
    "ui/**/*",
}

shared_scripts {
    "src/shared/print.lua",
    "src/shared/require.lua",

    "src/shared/classes/*.lua",
    "src/shared/**/class.lua",

    "src/shared/**/functions.lua",

    "init.lua"
}

client_scripts {
    "src/client/**/class.lua",
    "src/client/**/events.lua",
}

server_scripts {
    "src/server/classes/*.lua",

    "src/server/**/class.lua",
    "src/server/**/registry.lua",
    "src/server/**/events.lua",

    "src/server/utils.lua",

    "extensions/server/**/class.lua",
    "extensions/server/**/registry.lua",

    "tests/server/*.lua"
}

dependency "oxmysql"
provide "rig"