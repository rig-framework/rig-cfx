--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file src/shared/globals/locale.lua
--- @description Initializes global localization, loads language files, and exposes global translation helpers.

--- @section Imports

local Locale = require("src.shared.locale.class")

--- @section Initialization

local lang = GetConvar("rig:language", "en")
local i18n = Locale.new(lang)

local default_data = require_json("locales.en")
if default_data then i18n:load("en", default_data) end

if lang ~= "en" then
    local lang_data = require_json("locales." .. lang)
    if lang_data then i18n:load(lang, lang_data) end
end

--- @section Globals

_G.i18n = i18n
_G.locale = function(...)
    return i18n:translate(...)
end

--- @section Tests
--- @todo REMOVE

if IsDuplicityVersion() then

    RegisterCommand("setlang", function(source, args)
        if source ~= 0 then 
            print("warn", "This command can only be run from the server console.")
            return 
        end

        local target_lang = args[1]
        if not target_lang or target_lang == "" then
            print("warn", "Usage: setlang <lang_code> (e.g., setlang fr)")
            return
        end

        local lang_data = require_json("locales." .. target_lang)
        if not lang_data then
            print("error", ("Failed to load locale file: locales/%s.json"):format(target_lang))
            return
        end

        SetConvar("rig:language", target_lang)
        i18n:load(target_lang, lang_data)
        i18n:set_language(target_lang)

        print("success", ("Language changed to '%s'. Running tests:"):format(target_lang))
        print("success", locale("welcome.user", "Console"))
    end, true)

end