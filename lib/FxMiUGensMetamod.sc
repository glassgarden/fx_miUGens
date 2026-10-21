// Warps meta-modulator. With carrier 0 the left input is the carrier and the
// right input the modulator; with 1-3 Warps' own oscillator is the carrier and
// the summed input is the modulator.
FxMiUGensMetamod : FxMiUGensBase {

    *new {
        ^super.newCopyArgs(nil, \none, (
            carrier: 1,
            note: 48,
            algorithm: 2,
            timbre: 0.5,
            carrierLevel: 0.5,
            modLevel: 0.5,
            preGain: 1,
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
        ^"/fx_miugens_metamod";
    }

    symbol {
        ^\fxMiUGensMetamod;
    }

    ugen {
        ^\MiWarps;
    }

    addMiSynthdef { |mi|
        SynthDef(\fxMiUGensMetamod, {|inBus, outBus|
            var input = In.ar(inBus, 2);
            var carrier = \carrier.kr(1);
            var modulator = Select.ar(carrier > 0, [input[1], input.sum * 0.5]);
            var sig = mi.ar(
                input[0],
                modulator,
                lev1: \carrierLevel.kr(0.5),
                lev2: \modLevel.kr(0.5),
                algo: \algorithm.kr(2),
                timb: \timbre.kr(0.5),
                osc: carrier,
                freq: \note.kr(48).midicps,
                vgain: \preGain.kr(1),
                easteregg: \easteregg.kr(0),
            );
            Out.ar(outBus, (sig[0] * \level.kr(1)) ! 2);
        }).add;
    }
}
