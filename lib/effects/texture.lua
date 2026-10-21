return {
    id = "texture",
    ugen = "MiClouds",
    params = {
        { type = "option", id = "mode", options = { "granular", "stretch", "looping delay", "spectral" } },
        { type = "control", id = "position", spec = controlspec.new(0, 1, 'lin', 0, 0.5) },
        { type = "control", id = "size", spec = controlspec.new(0, 1, 'lin', 0, 0.5) },
        { type = "control", id = "pitch", spec = controlspec.new(-24, 24, 'lin', 0, 0, 'st') },
        { type = "control", id = "density", spec = controlspec.new(0, 1, 'lin', 0, 0.65) },
        { type = "control", id = "texture", spec = controlspec.new(0, 1, 'lin', 0, 0.5) },
        { type = "control", id = "spread", spec = controlspec.new(0, 1, 'lin', 0, 0.5) },
        { type = "control", id = "feedback", spec = controlspec.new(0, 1, 'lin', 0, 0) },
        { type = "control", id = "reverb", spec = controlspec.new(0, 1, 'lin', 0, 0) },
        { type = "toggle", id = "freeze" },
        { type = "toggle", id = "lofi" },
        { type = "taper", id = "in_gain", name = "input gain", key = "inGain", min = 0, max = 4, default = 1 },
    },
}
