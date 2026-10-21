// The reverb from Clouds and Rings.
FxMiUGensReverb : FxMiUGensBase {

    *new {
        ^super.newCopyArgs(nil, \none, (
            time: 0.7,
            damp: 0.5,
            hp: 0.05,
            diffusion: 0.625,
            freeze: 0,
            inGain: 1,
            drywet: 1,
        ), nil, 1);
    }

    *initClass {
        Class.initClassTree(FxSetup);
        FxSetup.register(this.new);
    }

    subPath {
        ^"/fx_miugens_reverb";
    }

    symbol {
        ^\fxMiUGensReverb;
    }

    ugen {
        ^\MiVerb;
    }

    addMiSynthdef { |mi|
        SynthDef(\fxMiUGensReverb, {|inBus, outBus|
            var input = In.ar(inBus, 2) * \inGain.kr(1);
            Out.ar(outBus, mi.ar(
                input,
                time: \time.kr(0.7),
                drywet: 1,
                damp: \damp.kr(0.5),
                hp: \hp.kr(0.05),
                freeze: \freeze.kr(0),
                diff: \diffusion.kr(0.625),
            ));
        }).add;
    }
}
