// Ripples 4-pole lowpass. MiRipples is mono, so this runs two of them, one per
// channel; spread pulls the two cutoffs apart.
FxMiUGensLowpass : FxMiUGensBase {

    *new {
        ^super.newCopyArgs(nil, \none, (
            freq: 0.5,
            spread: 0,
            resonance: 0.2,
            drive: 1,
            level: 1,
            drywet: 1,
        ), nil, 1);
    }

    *initClass {
        Class.initClassTree(FxSetup);
        FxSetup.register(this.new);
    }

    subPath {
        ^"/fx_miugens_lowpass";
    }

    symbol {
        ^\fxMiUGensLowpass;
    }

    ugen {
        ^\MiRipples;
    }

    addMiSynthdef { |mi|
        SynthDef(\fxMiUGensLowpass, {|inBus, outBus|
            var input = In.ar(inBus, 2);
            var freq = \freq.kr(0.5);
            var spread = \spread.kr(0);
            // the filter core inverts polarity; flip it back so insert dry/wet
            // blends add up instead of cancelling.
            Out.ar(outBus, mi.ar(
                input,
                cf: [freq - spread, freq + spread].clip(0, 1),
                reson: \resonance.kr(0.2),
                drive: \drive.kr(1),
            ).neg * \level.kr(1));
        }).add;
    }
}
