-- fx_miUGens: effects for the norns fx mod, built on mi-UGens.
-- Requires the fx mod (https://github.com/sixolet/fx) and mi-UGens in
-- SuperCollider Extensions. Pick which effects show up in
-- SYSTEM > MODS > FX_MIUGENS; changes apply the next time a script loads.
local fx = require("fx/lib/fx")
local mod = require 'core/mods'
local hook = require 'core/hook'
local tab = require 'tabutil'
local musicutil = require 'musicutil'
-- Begin post-init hack block (same as other fx mods, for older norns versions)
if hook.script_post_init == nil and mod.hook.patched == nil then
    mod.hook.patched = true
    local old_register = mod.hook.register
    local post_init_hooks = {}
    mod.hook.register = function(h, name, f)
        if h == "script_post_init" then
            post_init_hooks[name] = f
        else
            old_register(h, name, f)
        end
    end
    mod.hook.register('script_pre_init', '!replace init for fake post init', function()
        local old_init = init
        init = function()
            old_init()
            for i, k in ipairs(tab.sort(post_init_hooks)) do
                local cb = post_init_hooks[k]
                print('calling: ', k)
                local ok, error = pcall(cb)
                if not ok then
                    print('hook: ' .. k .. ' failed, error: ' .. error)
                end
            end
        end
    end)
end
-- end post-init hack block

local NAME = mod.this_name
local EXTENSIONS = "/home/we/.local/share/SuperCollider/Extensions"
local MI_UGENS_URL = "https://github.com/carlosedp/norns-mi-UGens/releases/latest/download/mi-UGens-norns.tar.gz"
local CONFIG_DIR = _path.data .. NAME .. "/"
local CONFIG = CONFIG_DIR .. "enabled.lua"

local effects = {}
for _, id in ipairs { "granular", "texture", "reverb", "lowpass", "mulaw", "metamod", "resonator" } do
    local e = require(NAME .. "/lib/effects/" .. id)
    e.fx = fx:new { subpath = "/fx_miugens_" .. id }
    table.insert(effects, e)
end

-- Effect ids switched on in the mod menu; all of them until the user saves a choice.
local enabled = tab.load(CONFIG)
if enabled == nil then
    enabled = {}
    for _, e in ipairs(effects) do enabled[e.id] = true end
end

local installed
local function has_ugen(ugen)
    if installed == nil then
        installed = {}
        local found = util.os_capture("find " .. EXTENSIONS .. " -name 'Mi*.sc' 2>/dev/null", true)
        for name in found:gmatch("(Mi%w+)%.sc") do installed[name] = true end
    end
    return installed[ugen] == true
end

local function missing_ugens()
    local missing = {}
    for _, e in ipairs(effects) do
        if not has_ugen(e.ugen) then table.insert(missing, e.ugen) end
    end
    return missing
end

-- Downloads the latest mi-UGens release and runs the install.sh inside it,
-- which moves older installs aside first. done(status) runs when finished, with
-- a line short enough for the menu; the full output goes to maiden.
local function install_mi_ugens(done)
    local cmd = "bash -c '" .. ([[
        d=$(mktemp -d); trap "rm -rf $d" EXIT
        wget -q -T 180 -O "$d/b.tgz" URL || { echo "download failed"; exit 1; }
        tar -C "$d" -xzf "$d/b.tgz" || { echo "bad tarball"; exit 1; }
        bash "$d/install.sh" "$d/mi-UGens"
    ]]):gsub("URL", MI_UGENS_URL):gsub("'", "'\\''") .. "' 2>&1; echo \"exit=$?\""
    norns.system_cmd(cmd, function(out)
        print(out)
        installed = nil
        if not out:match("exit=0") then
            done("failed, see maiden")
        elseif out:match("WARNING") then
            done("dupes, see maiden")
        else
            done("done: restart norns")
        end
    end)
end

local function send(e, key, val)
    osc.send({ "localhost", 57120 }, e.fx.subpath .. "/set", { key, val })
end

-- Adds one param from an effect's spec and returns its id.
local function add_param(e, p)
    local id = "fx_miugens_" .. e.id .. "_" .. p.id
    local name = p.name or (p.id:gsub("_", " "))
    local key = p.key or p.id
    if p.type == "control" then
        params:add_control(id, name, p.spec)
    elseif p.type == "taper" then
        params:add_taper(id, name, p.min, p.max, p.default, 2, p.units)
    elseif p.type == "option" then
        params:add_option(id, name, p.options, p.default or 1)
    elseif p.type == "toggle" then
        params:add_binary(id, name, "toggle", p.default or 0)
    elseif p.type == "number" then
        params:add_number(id, name, p.min, p.max, p.default)
    elseif p.type == "note" then
        params:add_number(id, name, 12, 108, p.default, function(param)
            return musicutil.note_num_to_name(param:get(), true)
        end)
    end
    params:set_action(id, function(val)
        -- options are 1-based in Lua, 0-based in the synths
        send(e, key, p.type == "option" and val - 1 or val)
    end)
    return id
end

local function add_effect(e)
    local prefix = "fx_miugens_" .. e.id
    -- +2 for the slot and the dry/wet that add_slot adds
    params:add_group(prefix, e.id, #e.params + 2)
    e.fx:add_slot(prefix .. "_slot", "slot")
    local ids = { prefix .. "_slot", prefix .. "_slot_drywet" }
    for _, p in ipairs(e.params) do
        table.insert(ids, add_param(e, p))
    end
    -- The script's params:bang() ran before these existed; push them now so
    -- SuperCollider matches the menu.
    for _, id in ipairs(ids) do
        params:lookup_param(id):bang()
    end
end

mod.hook.register("script_post_init", "fx miugens post init", function()
    local active = {}
    for _, e in ipairs(effects) do
        if enabled[e.id] and has_ugen(e.ugen) then table.insert(active, e) end
    end
    if #active == 0 then return end
    params:add_separator("fx_miugens", "fx miugens")
    for _, e in ipairs(active) do add_effect(e) end
end)

mod.hook.register("system_post_startup", "fx miugens post startup", function()
    local missing = missing_ugens()
    if #missing > 0 then
        print("fx miugens: " .. table.concat(missing, " ") .. " not found in SuperCollider Extensions;"
            .. " install mi-UGens from SYSTEM > MODS > FX_MIUGENS")
    end
end)

-- Mod menu: E2/K2 to move and leave, E3/K3 to switch an effect on or off.
-- The last row installs mi-UGens.
local m = { pos = 1, status = nil, busy = false }
local INSTALL_ROW = #effects + 1

local function set_enabled(e, on)
    if not has_ugen(e.ugen) or enabled[e.id] == on then return end
    enabled[e.id] = on
    util.make_dir(CONFIG_DIR)
    tab.save(enabled, CONFIG)
end

m.key = function(n, z)
    if z == 0 or m.busy then return end
    if n == 2 then
        mod.menu.exit()
    elseif n == 3 and m.pos == INSTALL_ROW then
        m.busy = true
        m.status = "downloading..."
        install_mi_ugens(function(status)
            m.busy = false
            m.status = status
            mod.menu.redraw()
        end)
        mod.menu.redraw()
    elseif n == 3 then
        local e = effects[m.pos]
        set_enabled(e, not enabled[e.id])
        mod.menu.redraw()
    end
end

m.enc = function(n, d)
    if m.busy then return end
    if n == 2 then
        m.pos = util.clamp(m.pos + d, 1, INSTALL_ROW)
    elseif n == 3 and m.pos ~= INSTALL_ROW then
        set_enabled(effects[m.pos], d > 0)
    end
    mod.menu.redraw()
end

m.redraw = function()
    screen.clear()
    screen.level(15)
    screen.move(0, 10)
    screen.text("FX MIUGENS")
    screen.level(4)
    screen.move(127, 10)
    local missing = #missing_ugens()
    if m.status then
        screen.text_right(m.status)
    elseif missing > 0 then
        screen.text_right(missing .. " missing, see below")
    else
        screen.text_right("applies on next load")
    end
    local first = util.clamp(m.pos - 2, 1, math.max(1, INSTALL_ROW - 4))
    for i = first, math.min(first + 4, INSTALL_ROW) do
        local y = 22 + (i - first) * 10
        screen.level(i == m.pos and 15 or 4)
        screen.move(0, y)
        if i == INSTALL_ROW then
            screen.text((missing > 0 and "install" or "update") .. " mi-UGens")
            screen.move(127, y)
            screen.text_right(m.busy and "..." or "K3")
        else
            local e = effects[i]
            screen.text(e.id)
            screen.move(127, y)
            if not has_ugen(e.ugen) then
                screen.text_right("missing " .. e.ugen)
            else
                screen.text_right(enabled[e.id] and "on" or "off")
            end
        end
    end
    screen.update()
end

m.init = function() end
m.deinit = function() end

mod.menu.register(NAME, m)
