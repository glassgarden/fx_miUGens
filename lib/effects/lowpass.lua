return {
    id = "lowpass",
    ugen = "MiRipples",
    params = {
        { type = "control", id = "freq", spec = controlspec.new(0, 1, 'lin', 0, 0.5) },
        { type = "control", id = "resonance", spec = controlspec.new(0, 1, 'lin', 0, 0.2) },
        { type = "control", id = "spread", name = "stereo spread", spec = controlspec.new(0, 0.25, 'lin', 0, 0) },
        { type = "taper", id = "drive", min = 1, max = 8, default = 1 },
        { type = "taper", id = "level", min = 0, max = 2, default = 1 },
    },
}
