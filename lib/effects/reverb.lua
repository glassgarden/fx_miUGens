return {
    id = "reverb",
    ugen = "MiVerb",
    params = {
        { type = "control", id = "time", spec = controlspec.new(0, 1, 'lin', 0, 0.7) },
        { type = "control", id = "damp", spec = controlspec.new(0, 1, 'lin', 0, 0.5) },
        { type = "control", id = "hp", name = "low cut", spec = controlspec.new(0, 1, 'lin', 0, 0.05) },
        { type = "control", id = "diffusion", spec = controlspec.new(0, 1, 'lin', 0, 0.625) },
        { type = "toggle", id = "freeze" },
        { type = "taper", id = "in_gain", name = "input gain", key = "inGain", min = 0, max = 4, default = 1 },
    },
}
