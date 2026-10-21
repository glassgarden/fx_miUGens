return {
    id = "metamod",
    ugen = "MiWarps",
    params = {
        { type = "option", id = "carrier", options = { "input left", "sine", "triangle", "saw" }, default = 2 },
        { type = "note", id = "note", default = 48 },
        { type = "control", id = "algorithm", spec = controlspec.new(0, 8, 'lin', 0, 2) },
        { type = "control", id = "timbre", spec = controlspec.new(0, 1, 'lin', 0, 0.5) },
        { type = "control", id = "carrier_level", name = "carrier level", key = "carrierLevel", spec = controlspec.new(0, 1, 'lin', 0, 0.5) },
        { type = "control", id = "mod_level", name = "mod level", key = "modLevel", spec = controlspec.new(0, 1, 'lin', 0, 0.5) },
        { type = "taper", id = "pre_gain", name = "pre gain", key = "preGain", min = 1, max = 10, default = 1 },
        { type = "toggle", id = "easteregg", name = "freq shifter" },
        { type = "taper", id = "level", min = 0, max = 2, default = 1 },
    },
}
