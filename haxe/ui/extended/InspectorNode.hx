package haxe.ui.extended;

import haxe.ui.containers.VBox;
import haxe.ui.containers.HBox;
import haxe.ui.components.Label;
import haxe.ui.core.Component;
import haxe.ui.events.UIEvent;
import haxe.ui.events.MouseEvent;
import haxe.ui.extended.TreeNode;
import haxe.ui.extended.InspectorField;
import haxe.ui.extended.NodeData;
import haxe.ui.extended.Util.Cli;
import haxe.ui.data.*;

#if arm_csm
import iron.data.SceneFormat;
import haxe.ui.extended.InspectorTypeTransformer;

typedef InspectorData ={
    >NodeData,
    var dataref:String;
    var px:Float;
    var py:Float;
    var pz:Float;
    var rx:Float;
    var ry:Float;
    var rz:Float;
    var sx:Float;
    var sy:Float;
    var sz:Float;
    var materialRefs:Array<String>;
    var particleRefs:Array<TParticleReference>;
    var isParticle:Bool;
    var groupref:String;
    var lods:Array<TLod>;
    var traits:Array<TTrait>;
    var properties:Array<TProperty>;
    var constraints:Array<TConstraint>;
    var objectActions:Array<String>;
    var boneActions:Array<String>;
    var visible:Bool;
    var visibleMesh:Bool;
    var visibleShadow:Bool;
    var mobile:Bool;
    var autoSpawn:Bool;
    var localOnly:Bool;
    var tilesheetRef:String;
    var tilesheetActionRef:String;
    var sampled:Bool;
    
} 
class Resolver{
    static public function resolve(field:String){
        switch(field){
            case 'isParticle'| 'visible' | 'visibleMesh'| 'mobile' | 'autoSpawn' | 'localOnly' | 'sampled':
                return "selected";
            case 'dataref' | 'groupref' | 'tilesheetActionRef' | 'tilesheetRef':
                return "text";
            // case 'materialRefs' | 'objectActions' | 'boneActions' | 'particleRefs' | 'lods' | 'traits' | 'parameters':
            //     return 'dataSource';
            default:
                return "pos";
        }
    }
}

@:build(haxe.ui.macros.ComponentMacros.build("haxe/ui/extended/custom/inspector-node.xml"))
#end
#if coin
import coin.data.SceneFormat;
import coineditor.InspectorTypeTransformer;
import Type;

typedef InspectorData ={
    >NodeData,
    var px:Float;
    var py:Float;
    var pz:Float;
    // var rx:Float;
    // var ry:Float;
    var rz:Float;
    var sx:Float;
    var sy:Float;
    var w:Float;
    var h:Float;
    var active:Bool;
    var imagePath:String;
    // var sz:Float;
    var traits:Array<TTrait>;
}
class Resolver{
    static public function resolve(type:Dynamic){
        var field = Type.typeof(type);
        // trace(field);
        switch(field){
            case ValueType.TBool:
                return "selected";
            case ValueType.TClass(String):
                return "text";
            default:
                return "pos";
        }
    }
}

@:build(haxe.ui.macros.ComponentMacros.build("haxe/ui/extended/custom/coin-inspector-node.xml"))
#end
class InspectorNode extends TreeNode {

    public function new(data:InspectorData = null,tv:TreeView = null, updateData:UIEvent->Void =null) {
        super(data,tv);
        this.removeComponent(expander);
        //populate transform
        for(f in Reflect.fields(transform)){
            if(Reflect.hasField(data,f)){
                var temp = Reflect.field(transform,f);
                var out = Reflect.getProperty(data,f);
                Reflect.setProperty(temp,Resolver.resolve(out),Reflect.field(data,f));
                Reflect.setProperty(transform,f,temp);
                temp.registerEvent(UIEvent.CHANGE,updateData);
            }
        }

        var ds = new ArrayDataSource<Dynamic>(new InspectorTypeTransformer());
        //populate the rest
        for(f in Reflect.fields(this)){
            if(f == "transform" || StringTools.contains(f,"_"))continue;
            var temp = Reflect.getProperty(this,f);
            var isComponent = Std.is(temp,Component);
            
            if(Reflect.hasField(data,f)){
                
                var out = Reflect.getProperty(data,f);
                var type = Resolver.resolve(out);
                if(Std.is(temp,InspectorField)){
                    if(tv.rclickItems != null)temp.tree.rclickItems = tv.rclickItems; 
                    var value:Array<Dynamic> = out;
                    ds.clear();
                    
                    if(temp.text != null)
                        temp.name.text = temp.text;

                    for(v in value){
                        ds.add(v);
                        var ndata = ds.get(ds.size-1);
                        temp.addField(ndata);
                    }
                }
                else{
                    Reflect.setProperty(temp,type,out);
                }
                if(isComponent && updateData != null){
                    temp.registerEvent(UIEvent.CHANGE,updateData);
                }
                    
                Reflect.setProperty(this,f,temp);
            }
            else if( isComponent && !Std.is(temp,InspectorField) && f != "expander" && Reflect.getProperty(this,'box$f') != null){
                #if editor_dev
                trace(Cli.yellow+"WARNING:"+Cli.reset+'Component with id $f was removed because the data did not have it');
                #end
                // this.removeComponent(Reflect.getProperty(this,f));
                this.removeComponent(Reflect.getProperty(this,'box$f'));
            }
        }
        ins_hbox.invalidateComponent();
        tv.rclickItems = [];
    }

    public function updateNode(data:InspectorData){
        for(f in Reflect.fields(transform)){
            if(Reflect.hasField(data,f)){
                var temp = Reflect.field(transform,f);
                var out = Reflect.getProperty(data,f);
                Reflect.setProperty(temp,Resolver.resolve(out),Reflect.field(data,f));
                Reflect.setProperty(transform,f,temp);
            }
        }
    }

    public override function addNode(data:NodeData) {
        _expanded = true;
        var newNode = new InspectorNode(cast(data),_tv);
        newNode.marginLeft = 16;
        newNode.parentNode = this;
        newNode.hide();
        addComponent(newNode);
        return newNode;
    }
}