return {
    id = "resonator",
    ugen = "MiRings",
    params = {
        { type = "option", id = "model", options = { "modal", "symp. strings", "inharm. string", "2-op fm", "western chords", "reverb string" } },
        { type = "note", id = "note", default = 48 },
        { type = "number", id = "poly", min = 1, max = 4, default = 1 },
        { type = "control", id = "structure", spec = controlspec.new(0, 1, 'lin', 0, 0.25) },
        { type = "control", id = "brightness", spec = controlspec.new(0, 1, 'lin', 0, 0.5) },
        { type = "control", id = "damping", spec = controlspec.new(0, 1, 'lin', 0, 0.7) },
        { type = "control", id = "position", spec = controlspec.new(0, 1, 'lin', 0, 0.25) },
        { type = "control", id = "strum_thresh", name = "strum threshold", key = "strumThresh", spec = controlspec.new(0, 1, 'lin', 0, 0.1) },
        { type = "taper", id = "in_gain", name = "input gain", key = "inGain", min = 0, max = 4, default = 1 },
        { type = "toggle", id = "easteregg", name = "disastrous peace" },
        { type = "taper", id = "level", min = 0, max = 2, default = 1 },
    },
}
