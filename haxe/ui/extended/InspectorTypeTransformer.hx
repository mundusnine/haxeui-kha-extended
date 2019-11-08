package haxe.ui.extended;

import haxe.ui.data.transformation.IItemTransformer;
// import iron.data.SceneFormat;

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
            var par:Array<String>=[];
            if(Reflect.hasField(i,"props")){
                var a:Array<String> = i.props; 
                for(p in a){
                    par.push(this.transformFrom(p));
                }
            }
            var t:Array<String> = i.class_name.split(".");
            o = {type: "img/"+i.type.toLowerCase(), name: t[t.length-1],nameClass: i.class_name,props: par};
        }else if(Reflect.hasField(i,"name") && Reflect.hasField(i,"value")){
            if(Std.is(i.value,String)){
                o = {name: i.name, str: i.value};
            }else if( Std.is(i.value, Bool)){
                o = {name: i.name,bool: i.value} ;
            }else if( Std.is(i.value, Int)){
                o = {name: i.name,int: i.value} ;
            }else if( Std.is(i.value, Float)){
                o = {name: i.name,float: i.value} ;
            }
            
        }else if(Reflect.hasField(i,"name") && Reflect.hasField(i,"type")){
            o = {
                constrName: i.name, constrType: i.type,bone:"",target: "",
                useX: false,useY: false, useZ: false,
                invertX: false, invertY: false, invertZ: false, useOffset: false, influence: 0.0};
                var temp:Map<String, Int> = [ "X" => 0, "Y"=>0, "Z"=>0];
                for(f in Reflect.fields(o)){
                    if(f == "constrType" || f== "constrName")
                        continue;
                    var of = f;
                    if(temp.exists(f.charAt(f.length))){
                        f = f.substr(0,f.length-1)+"_"+f.charAt(f.length).toLowerCase();
                    }
                    if(StringTools.endsWith(f,"Offset")){
                        f = StringTools.replace(f,"Offset","_offset");
                    }
                    if(!Reflect.hasField(i,f)){
                        Reflect.deleteField(o,of);
                    }
                    else{
                        Reflect.setProperty(o,of,Reflect.field(i,f));
                    }
                }
            
        }else {
            o = i;
        }
        return o;
    }

}