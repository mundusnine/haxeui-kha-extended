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
        } else if(Reflect.hasField(i,"name") && Reflect.hasField(i,"particle")&& Reflect.hasField(i,"seed")){//TParticleReference
            o = {partname: i.name,particle: i.particle,seed: i.seed};
        } else if(Reflect.hasField(i,"object_ref") && Reflect.hasField(i,"screen_size")){//TLod
            o = {objectRef: i.object_ref, screenSize: i.screen_size};
        } else if(Reflect.hasField(i,"type") && Reflect.hasField(i,"class_name")){//TTrait
            var par =[];
            if(Reflect.hasField(i,"props")){
                var a:Array<String> = i.props; 
                for(p in a){
                    par.push(this.transformFrom(p));
                }
            }
            var t:Array<String> = i.class_name.split(".");
            o = {type: "img/"+i.type.toLowerCase(), name: t[t.length-1],nameClass: i.class_name,props: par};
        }else {
            o = i;
        }
        return o;
    }

}