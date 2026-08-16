--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @class Locale
--- @file src/shared/classes/locale.lua
--- @description Handles i18n localization with dot-notation lookup, player language overrides, and fallback support.

--- @section Initialisation

local Locale = {}
Locale.__index = Locale

--- @section Functions

local function resolve_key(dict, key)
    if not dict or type(key) ~= "string" then return nil end
    if dict[key] then return dict[key] end

    local current = dict
    for part in key:gmatch("[^%.]+") do
        if type(current) ~= "table" then return nil end
        current = current[part]
    end
    return current
end

--- @section Factory

function Locale.new(default_lang)
    return setmetatable({
        current_lang = default_lang or "en",
        locales = {},
        player_langs = {}
    }, Locale)
end

--- @section Methods

function Locale:load(lang, dict)
    if type(dict) ~= "table" then return end
    self.locales[lang] = self.locales[lang] or {}
    for k, v in pairs(dict) do
        self.locales[lang][k] = v
    end
end

function Locale:set_language(lang)
    self.current_lang = lang
end

function Locale:set_player_language(source, lang)
    self.player_langs[source] = lang
end

function Locale:remove_player(source)
    self.player_langs[source] = nil
end

function Locale:get_language(source)
    if source and self.player_langs[source] then
        return self.player_langs[source]
    end
    return self.current_lang
end

function Locale:translate(...)
    local first = select(1, ...)
    local source, key, start_idx

    if type(first) == "number" then
        source = first
        key = select(2, ...)
        start_idx = 3
    else
        source = nil
        key = first
        start_idx = 2
    end

    local lang = self:get_language(source)
    local str = resolve_key(self.locales[lang], key)

    if not str and lang ~= "en" then
        str = resolve_key(self.locales["en"], key)
    end

    local total = select("#", ...)
    local fmt_args = {}
    for i = start_idx, total do
        table.insert(fmt_args, (select(i, ...)))
    end

    if type(str) == "string" then
        if #fmt_args > 0 then
            local ok, res = pcall(string.format, str, table.unpack(fmt_args))
            return ok and res or str
        end
        return str
    end

    if #fmt_args > 0 then
        for i = 1, #fmt_args do fmt_args[i] = tostring(fmt_args[i]) end
        return ("%s | %s"):format(tostring(key), table.concat(fmt_args, ", "))
    end

    return tostring(key)
end

return Locale