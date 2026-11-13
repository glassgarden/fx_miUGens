# fx_miUGens

_Eurorack-born effects for the norns [fx mod](https://github.com/sixolet/fx)_

Seven effects built on [mi-UGens](https://github.com/glassgarden/mi-UGens). Each one can
sit on send A, send B or the insert slot, under any script.

| Effect        | What it does                                                                                                                                                          |
| ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **granular**  | Granular processor with four quality modes (hi-fi to dirty tape) and a built-in reverb                                                                                |
| **texture**   | Texture processor: granular, stretch, looping delay and spectral modes                                                                                                |
| **reverb**    | Lush reverb with freeze                                                                                                                                               |
| **lowpass**   | 4-pole analog-style lowpass, one per channel; _stereo spread_ pulls the two cutoffs apart                                                                             |
| **mulaw**     | µ-law companding: 8-bit crunch, more of it the harder you drive                                                                                                       |
| **metamod**   | Cross-modulation, ring mod, vocoder. The carrier is a built-in oscillator at _note_, modulated by the input; or set carrier to _input left_ to modulate left by right |
| **resonator** | Strings and modal resonator excited by the input. Loud transients strum it; raise _strum threshold_ to stop that                                                      |

## Install

1. Install the [fx mod](https://github.com/sixolet/fx).
2. In maiden: `;install https://github.com/glassgarden/fx_miUGens`
3. SYSTEM > MODS: enable **fx** and **fx_miUGens**, then SYSTEM > RESTART.
4. If mi-UGens isn't installed yet (or is an older copy without MiBeads or MiWarps), the first
   script you load after that asks for them: a [norns-deps](https://github.com/vehka/norns-deps)
   screen that downloads a pinned, checksum-verified
   [mi-UGens](https://github.com/glassgarden/mi-UGens) release and moves older copies aside. K3
   installs, then K3 again restarts norns. It asks only once: if you said "not now" (K2), open
   SYSTEM > MODS > `FX_MIUGENS` and press K3 on **install mi-UGens** at the bottom. If you already installed it for
   [terrarium](https://github.com/glassgarden/terrarium), which shares it, there's nothing to do.
   A **remove mi-UGens** row appears below it once this mod has installed them; it only removes
   what this mod put in.

## Use

Load any script. Under PARAMETERS > EDIT, the **fx miugens** section has one folder per effect;
set its **slot** to send a, send b or insert. Scripts that support fx sends have send a / send b
levels; insert processes everything.

**Pick your effects:** SYSTEM > MODS > `FX_MIUGENS` lists every effect. E2 to move, E3 or K3
to switch one on or off, K2 to leave. Switched-off effects don't add params. Changes apply the
next time a script loads. Effects whose UGen isn't installed show as **missing**; the last row
installs or updates mi-UGens, and a row below it removes them again.

## Good to know

- **CPU:** granular, texture and resonator are heavy. Running two of them at once on a norns
  (CM3) is likely to crackle.
- **fx_grains and fx_resonator** can stay installed. fx_miUGens uses its own names, so they
  don't clash.
- A missing UGen only disables that effect; the rest still load. If the fx mod itself is
  missing, though, SuperCollider can't compile these classes and norns' audio won't start, as
  with any fx effect.
- A script loads its PSET before mods add their params, so these settings aren't restored from
  it, as with other fx effects.

## Credits

The DSP is Émilie Gillet's code for the Mutable Instruments eurorack modules, which she
released as open source, ported to SuperCollider by Volker Böhm as
[mi-UGens](https://github.com/v7b1/mi-UGens). This project isn't affiliated with or endorsed
by Mutable Instruments.

| Effect    | Based on                         | UGen      |
| --------- | -------------------------------- | --------- |
| granular  | Beads                            | MiBeads   |
| texture   | Clouds                           | MiClouds  |
| reverb    | the reverb from Clouds and Rings | MiVerb    |
| lowpass   | Ripples                          | MiRipples |
| mulaw     | Mu                               | MiMu      |
| metamod   | Warps                            | MiWarps   |
| resonator | Rings                            | MiRings   |

## License

GPL-3.0, like mi-UGens. `lib/deps.lua` and `lib/deps/` are
[norns-deps](https://github.com/vehka/norns-deps) (MIT, by vehka), vendored.
