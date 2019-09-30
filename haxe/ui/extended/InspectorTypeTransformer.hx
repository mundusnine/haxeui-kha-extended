package haxe.ui.extended;

import haxe.ui.data.transformation.IItemTransformer;
import iron.data.SceneFormat;

class InspectorTypeTransformer implements IItemTransformer<Dynamic> {
    public function new() {
    }

    public function transformFrom(i:Dynamic):Dynamic {
        var o:Dynamic = null;
        if (Std.is(i, String)) {
            o = { tfield: i };
        } else if (Std.is(i, Int) || Std.is(i, Float) || Std.is(i, Bool)) {
            o = { value: i };
        } else if(Std.is(i,{name: "", particle: "", seed: 1})){//TParticleReference
            o = {partname: i.name,particle: i.particle,seed: i.seed};
        } else if(Std.is(i,{object_ref: "", screen_size: 0.0})){//TLod
            o = {objectRef: i.object_ref, screenSize: i.screen_size};
        }else {
            o = i;
        }
        return o;
    }

}