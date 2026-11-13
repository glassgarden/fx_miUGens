-- needs: fx_miUGens plays mi-UGens, installed and removed through norns-deps
-- (lib/deps.lua and lib/deps/, vendored from github.com/vehka/norns-deps, MIT;
-- terrarium uses the same copy).
--
-- The install downloads a pinned norns build of mi-UGens (checked against its
-- sha256) and runs the install.sh inside it, which moves older mi-UGens installs
-- aside. norns-deps' manifest (in this mod's data folder) records what it
-- installed, so remove() takes away only that, never a copy that was already
-- there (or one terrarium put in).
--
-- norns-deps probes the machine as it loads, so it is loaded only when a screen opens.
--
--   N.install(done)     the install screen; done(ok, needs_restart) once it closes
--   N.installed()       did this mod install mi-UGens (and are they still there)?
--   N.remove(done)      the remove screen; done(ok)

local N = {}

-- the mod's folder name, from the name it was required by
local MOD = (...):match("^(.-)/lib/needs$")

N.DIR = _path.data .. MOD .. "/deps"

local ID = "mi-UGens"
local VERSION = "v1.2.0"
local FILE = "mi-UGens-norns-" .. VERSION .. ".tar.gz"
local URL = "https://github.com/glassgarden/mi-UGens/releases/download/" .. VERSION .. "/" .. FILE
local SHA256 = "f997afea8a38f1f43f2a86c639c6c1a8f841591e31ce3cf698f1bf97e44864b4"

local function q(s) return "'" .. s:gsub("'", "'\\''") .. "'" end

local function exists(path)
    local f = io.open(path, "r")
    if f then f:close() end
    return f ~= nil
end

local function deps(check)
    local D = require(MOD .. "/lib/deps")
    local d = D.new { name = MOD, dir = N.DIR }
    local tarball = N.DIR .. "/downloads/" .. FILE
    -- unpacked outside dust (sclang compiles every class file it finds there)
    local install = table.concat({
        "d=$(mktemp -d) || exit 1",
        "trap 'rm -rf \"$d\"' EXIT",
        "tar -C \"$d\" -xzf " .. q(tarball) .. " || { echo 'bad tarball'; exit 1; }",
        "bash \"$d/install.sh\" \"$d/mi-UGens\" || exit 1",
        "rm -f " .. q(tarball),
    }, "\n")
    d:add {
        id = ID, label = "mi-UGens " .. VERSION, size = "3 MB",
        why = "the effects' sound modules",
        check_fn = check,
        restart = true, -- SuperCollider loads them as it starts
        install = { { when = { arch = "armv7l" }, steps = {
            { url = URL, sha256 = SHA256, label = "download " .. VERSION },
            { cmd = install, step_label = "install" },
        } } },
        manual = "a norns-only build; see github.com/glassgarden/mi-UGens",
        uninstall = { { cmd = "rm -rf \"$HOME/.local/share/SuperCollider/Extensions/mi-UGens\"",
            step_label = "remove Extensions/mi-UGens" } },
    }
    return d
end

-- always opens the screen, so it also serves as "update"
function N.install(done)
    deps(function() return false end):ensure({ ID }, { on_done = function(ok, _, _, restart) done(ok, restart) end })
end

-- the manifest is there only while it lists something
function N.installed() return exists(N.DIR .. "/manifest.lua") end

function N.remove(done)
    deps(function() return false end):remove(nil, { on_done = function(ok) done(ok) end })
end

return N
