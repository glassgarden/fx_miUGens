// Shared plumbing for the fx_miUGens effects (https://github.com/sixolet/fx).
//
// Every .sc file under dust/ is compiled whether or not the mod is enabled, so
// naming a missing class like MiBeads directly would break the whole class
// library. Subclasses name their mi-UGen as a symbol instead and get the class
// passed in; if it isn't installed the synthdef is skipped with a warning.
FxMiUGensBase : FxBase {

    // Virtual. Override me: the mi-UGen class this effect needs, e.g. \MiBeads.
    ugen {
        ^nil;
    }

    // Virtual. Override me: add the synthdef, calling mi.ar in place of the UGen.
    addMiSynthdef { |mi|
    }

    addSynthdefs {
        var mi = this.ugen.asClass;
        if (mi.isNil, {
            "fx_miUGens: % not installed, skipping %\n".postf(this.ugen, this.symbol);
        }, {
            this.addMiSynthdef(mi);
        });
    }
}
