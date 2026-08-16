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
    "src/core/shared/print.lua",
    "src/core/shared/require.lua",

    "src/core/shared/classes/*.lua",
    "src/core/shared/**/class.lua",

    "src/core/shared/**/registry.lua",
    "src/core/shared/**/functions.lua",

    "init.lua"
}

client_scripts {
    "src/core/client/gui/*.lua",

    "src/core/client/**/class.lua",
    "src/core/client/**/registry.lua",
    "src/core/client/**/functions.lua",
    "src/core/client/**/events.lua",

    "src/core/client/gameplay.lua",

    "tests/client/*.lua"
}

server_scripts {
    "src/core/server/gui/*.lua",

    "src/core/server/classes/*.lua",

    "src/core/server/**/class.lua",
    "src/core/server/**/registry.lua",
    "src/core/server/**/events.lua",

    "src/core/server/utils.lua",

    "src/extensions/server/**/class.lua",
    "src/extensions/server/**/registry.lua",

    "tests/server/*.lua"
}

dependency "oxmysql"
provide "rig"