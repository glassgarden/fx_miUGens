// Mu: 8-bit µ-law companding, one MiMu per channel.
FxMiUGensMulaw : FxMiUGensBase {

    *new {
        ^super.newCopyArgs(nil, \none, (
            gain: 1,
            level: 1,
            drywet: 1,
        ), nil, 1);
    }

    *initClass {
        Class.initClassTree(FxSetup);
        FxSetup.register(this.new);
    }

    subPath {
        ^"/fx_miugens_mulaw";
    }

    symbol {
        ^\fxMiUGensMulaw;
    }

    ugen {
        ^\MiMu;
    }

    addMiSynthdef { |mi|
        SynthDef(\fxMiUGensMulaw, {|inBus, outBus|
            var input = In.ar(inBus, 2);
            Out.ar(outBus, mi.ar(input, gain: \gain.kr(1)) * \level.kr(1));
        }).add;
    }
}
