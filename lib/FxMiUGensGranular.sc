// Beads granular processor.
FxMiUGensGranular : FxMiUGensBase {

    *new {
        ^super.newCopyArgs(nil, \none, (
            quality: 0,
            time: 0.5,
            size: 0.5,
            shape: 0.5,
            density: 0.7,
            pitch: 0,
            feedback: 0,
            reverb: 0,
            freeze: 0,
            inGain: 1,
            pitchRnd: 0,
            timeRnd: 0,
            sizeRnd: 0,
            shapeRnd: 0,
            drywet: 1,
        ), nil, 1);
    }

    *initClass {
        Class.initClassTree(FxSetup);
        FxSetup.register(this.new);
    }

    subPath {
        ^"/fx_miugens_granular";
    }

    symbol {
        ^\fxMiUGensGranular;
    }

    ugen {
        ^\MiBeads;
    }

    addMiSynthdef { |mi|
        SynthDef(\fxMiUGensGranular, {|inBus, outBus|
            var input = In.ar(inBus, 2);
            // seed is deliberately not passed: any UGen there counts as "patched"
            // and stops density from generating grains on its own.
            // drywet stays at 1; the fx framework mixes dry/wet for insert slots.
            Out.ar(outBus, mi.ar(
                input,
                pitch: \pitch.kr(0),
                pitch_rnd: \pitchRnd.kr(0),
                time: \time.kr(0.5),
                time_rnd: \timeRnd.kr(0),
                size: \size.kr(0.5),
                size_rnd: \sizeRnd.kr(0),
                shape: \shape.kr(0.5),
                shape_rnd: \shapeRnd.kr(0),
                density: \density.kr(0.7),
                fb: \feedback.kr(0),
                drywet: 1,
                rvb: \reverb.kr(0),
                freeze: \freeze.kr(0),
                seed_btn: 2,
                quality: \quality.kr(0),
                in_gain: \inGain.kr(1),
            ));
        }).add;
    }
}
