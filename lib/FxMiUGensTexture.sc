// Clouds texture processor, all four modes.
FxMiUGensTexture : FxMiUGensBase {

    *new {
        ^super.newCopyArgs(nil, \none, (
            mode: 0,
            pitch: 0,
            position: 0.5,
            size: 0.5,
            density: 0.65,
            texture: 0.5,
            spread: 0.5,
            feedback: 0,
            reverb: 0,
            freeze: 0,
            lofi: 0,
            inGain: 1,
            drywet: 1,
        ), nil, 1);
    }

    *initClass {
        Class.initClassTree(FxSetup);
        FxSetup.register(this.new);
    }

    subPath {
        ^"/fx_miugens_texture";
    }

    symbol {
        ^\fxMiUGensTexture;
    }

    ugen {
        ^\MiClouds;
    }

    addMiSynthdef { |mi|
        SynthDef(\fxMiUGensTexture, {|inBus, outBus|
            var input = In.ar(inBus, 2);
            Out.ar(outBus, mi.ar(
                input,
                pit: \pitch.kr(0),
                pos: \position.kr(0.5),
                size: \size.kr(0.5),
                dens: \density.kr(0.65),
                tex: \texture.kr(0.5),
                drywet: 1,
                in_gain: \inGain.kr(1),
                spread: \spread.kr(0.5),
                rvb: \reverb.kr(0),
                fb: \feedback.kr(0),
                freeze: \freeze.kr(0),
                mode: \mode.kr(0),
                lofi: \lofi.kr(0),
            ));
        }).add;
    }
}
