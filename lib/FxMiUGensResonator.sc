// Rings as an Elements-style resonator: the input excites the strings or modes
// directly, and loud transients in it strum them.
FxMiUGensResonator : FxMiUGensBase {

    *new {
        ^super.newCopyArgs(nil, \none, (
            note: 48,
            model: 0,
            poly: 1,
            structure: 0.25,
            brightness: 0.5,
            damping: 0.7,
            position: 0.25,
            strumThresh: 0.1,
            inGain: 1,
            easteregg: 0,
            level: 1,
            drywet: 1,
        ), nil, 1);
    }

    *initClass {
        Class.initClassTree(FxSetup);
        FxSetup.register(this.new);
    }

    subPath {
        ^"/fx_miugens_resonator";
    }

    symbol {
        ^\fxMiUGensResonator;
    }

    ugen {
        ^\MiRings;
    }

    addMiSynthdef { |mi|
        SynthDef(\fxMiUGensResonator, {|inBus, outBus|
            var input = In.ar(inBus, 2).sum * 0.5 * \inGain.kr(1);
            // an audio-rate trig turns off MiRings' own strum detection, which
            // only listens to the input when the pitch isn't modulated.
            var strum = Amplitude.ar(input, 0.001, 0.05) > \strumThresh.kr(0.1);
            Out.ar(outBus, mi.ar(
                input,
                trig: strum,
                pit: \note.kr(48),
                struct: \structure.kr(0.25),
                bright: \brightness.kr(0.5),
                damp: \damping.kr(0.7),
                pos: \position.kr(0.25),
                model: \model.kr(0),
                poly: \poly.kr(1),
                intern_exciter: 0,
                easteregg: \easteregg.kr(0),
            ) * \level.kr(1));
        }).add;
    }
}
