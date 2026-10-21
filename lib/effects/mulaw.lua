return {
    id = "mulaw",
    ugen = "MiMu",
    params = {
        { type = "taper", id = "gain", name = "drive", min = 0.25, max = 10, default = 1 },
        { type = "taper", id = "level", min = 0, max = 2, default = 1 },
    },
}
