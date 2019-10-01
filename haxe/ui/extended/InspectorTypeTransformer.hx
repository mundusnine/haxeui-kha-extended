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
            if(Reflect.hasField(i,"parameters")){
                var a:Array<String> = i.parameters; 
                for(p in a){
                    par.push(this.transformFrom(p));
                }
            }
            var props = Reflect.hasField(i,"props") ? i.props: [];
            trace(par);
            o = {typeName: i.type, className: i.class_name,parameters: par,props: props};
        }else {
            o = i;
        }
        return o;
    }

}