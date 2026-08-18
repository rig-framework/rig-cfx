--[[
----------------------------------------
RIG Framework (built for CFX Platforms)

Author: Case (https://caseirl.dev)
Repo: https://github.com/rig-framework/rig-cfx
License: https://github.com/rig-framework/rig-cfx/blob/main/LICENSE
----------------------------------------
]]

--- @file init.lua
--- @description Main initialisation file for script
--- Handles setting up namespaces, module loader and a few other things.

--- @section Constants

local PRINT = print
local RES_NAME = GetCurrentResourceName()
local SERVER = IsDuplicityVersion()
local CLIENT = not SERVER
local RELEASES_URL = "https://api.github.com/repos/rig-framework/rig-cfx/releases/latest"
local SEPARATOR = "^2---------------------------------------------------------------------^7"

--- @section Namespace

rig = setmetatable({
    name = RES_NAME,
    client = not SERVER,
    server = SERVER,
    metadata = {
        name = GetResourceMetadata(RES_NAME, "name", 0) or RES_NAME,
        desc = GetResourceMetadata(RES_NAME, "description", 0) or "N/A",
        version = GetResourceMetadata(RES_NAME, "version", 0) or "1.0.0",
        author = GetResourceMetadata(RES_NAME, "author", 0) or "Unknown"
    },
    settings = {
        general = {
            language = GetConvar("rig:language", "en"),
            debug = GetConvarBool("rig:debug", false),
            small_console_splash = GetConvarBool("rig:small_console_splash", false),
            connection_messages = GetConvarBool("rig:connection_messages", true),
        },

        users = {
            unique_id_chars = GetConvarInt("rig:users:unique_id_chars", 6),
            username_prefix = GetConvar("rig:users:username_prefix", "player"),
        },

        gameplay = {
            disable_dispatch = GetConvarBool("rig:gameplay:disable_dispatch", true),
            disable_police_scanner = GetConvarBool("rig:gameplay:disable_police_scanner", true),
            disable_garbage_trucks = GetConvarBool("rig:gameplay:disable_garbage_trucks", true),
            disable_random_cops = GetConvarBool("rig:gameplay:disable_random_cops", true),
            disable_wanted = GetConvarBool("rig:gameplay:disable_wanted", true),
            disable_weapon_autoreload = GetConvarBool("rig:gameplay:disable_weapon_autoreload", true),
            disable_weapon_autoswap = GetConvarBool("rig:gameplay:disable_weapon_autoswap", true),
            hide_ammo = GetConvarBool("rig:gameplay:hide_ammo", true),
            invalidate_idle_cam = GetConvarBool("rig:gameplay:invalidate_idle_cam", true),
            artificial_lights = GetConvarBool("rig:gameplay:artificial_lights", true),
            hide_hud_components = GetConvarBool("rig:gameplay:hide_hud_components", true),
            hud_components = GetConvar("rig:gameplay:hud_components", "1,2,3,4,5,6,7,8,9,13,19,20,21,22"),
            disable_controls = GetConvarBool("rig:gameplay:disable_controls", true),
            disable_controls_list = GetConvar("rig:gameplay:disable_controls_list", "37,157,158,160,161,256,257"),
        },

        extensions = {
            
        }
    },
}, {
    __tostring = function(t)
        local ver = t.metadata and t.metadata.version or "1.0.0"
        return ("RIG Framework v%s (https://rig.li) - Developed by Case (https://caseirl.dev)"):format(ver)
    end
})

if SERVER then
    local function log_setting(key, value)
        local function format_value(v)
            if type(v) == "boolean" then return v and "^2true" or "^1false" end
            if type(v) == "number" and (v == 0 or v == 1) then return v == 1 and "^2true" or "^1false" end
            return "^2" .. tostring(v)
        end
        if type(value) == "table" then
            PRINT("^7    " .. key .. ":")
            for k, v in pairs(value) do PRINT("^7      " .. k .. ": " .. format_value(v)) end
        else
            PRINT("^7    " .. key .. ": " .. format_value(value))
        end
    end

    local function render_startup(remote, current_ver)
        local is_mismatch = remote and remote.version and (tostring(remote.version) ~= tostring(current_ver))
        local ver_tag = not remote and ("^8[Unable to verify]^7") or is_mismatch and ("^3[v" .. remote.version .. " Available]^7") or ("^2[Up to date]^7")

        if rig.settings.small_console_splash then
            PRINT(SEPARATOR)
            PRINT(("^7[%s] ^2v%s^7 %s"):format(rig.metadata.name, current_ver, ver_tag))
            if is_mismatch then
                PRINT("^3Update available -- disable small_console_splash for changelog details^7")
            end
            PRINT(SEPARATOR)
            return
        end

        PRINT(SEPARATOR)
        PRINT("^2█████▄  ██  ▄████    ██     ██^7")
        PRINT("^2██▄▄██▄ ██ ██  ▄▄▄   ██     ██^7")
        PRINT("^2██   ██ ██  ▀███▀  ▄ ██████ ██^7")
        PRINT(SEPARATOR)
        PRINT("^7Name: ^2" .. rig.metadata.name .. "^7")
        PRINT("^7Description: ^2" .. rig.metadata.desc .. "^7")
        PRINT("^7Author: ^2" .. rig.metadata.author .. "^7")
        PRINT(("^7Version: %s %s"):format(is_mismatch and "^1v" .. current_ver or "^2v" .. current_ver, ver_tag))
        PRINT("^7Language: ^2" .. (rig.settings.language or "en") .. "^7")

        if is_mismatch then
            PRINT(SEPARATOR)
            PRINT("^1[!] UPDATE AVAILABLE FOR RIG [!]^7")
            if remote.download then
                PRINT("^7Download: ^5" .. remote.download .. "^7")
            end
            if type(remote.changelog) == "table" and #remote.changelog > 0 then
                PRINT("^7Changelog:^7")
                for i = 1, #remote.changelog do
                    PRINT("  ^3* " .. remote.changelog[i] .. "^7")
                end
            end
        end

        PRINT(SEPARATOR)
        PRINT("^7Settings:^7")
        for key, value in pairs(rig.settings) do
            log_setting(key, value)
        end
        PRINT(SEPARATOR)
    end

    local function check_release(current_ver)
        PerformHttpRequest(RELEASES_URL, function(status, body)
            if status ~= 200 then
                return render_startup(nil, current_ver)
            end

            local ok, release = pcall(json.decode, body or "")
            if not ok or type(release) ~= "table" or not release.tag_name then
                return render_startup(nil, current_ver)
            end

            local remote = {
                version = release.tag_name:gsub("^v", ""),
                download = release.html_url,
                changelog = {}
            }

            if type(release.body) == "string" and release.body ~= "" then
                for line in release.body:gmatch("[^\r\n]+") do
                    remote.changelog[#remote.changelog + 1] = line
                end
            end

            render_startup(remote, current_ver)
        end, "GET", "", { ["User-Agent"] = "CASEIRL-VersionChecker" })
    end

    check_release(rig.metadata.version)
end