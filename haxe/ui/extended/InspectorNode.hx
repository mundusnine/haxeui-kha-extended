package haxe.ui.extended;

import haxe.ui.containers.VBox;
import haxe.ui.containers.HBox;
import haxe.ui.components.Label;
import haxe.ui.core.Component;
import haxe.ui.events.UIEvent;
import haxe.ui.events.MouseEvent;
import haxe.ui.extended.TreeNode;
import haxe.ui.extended.NodeData;
import haxe.ui.data.*;


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
    var isParticle:Bool;
    var groupref:String;
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
    inline static public function resolve(field:String){
        switch(field){
            case 'isParticle'| 'visible' | 'visibleMesh'| 'mobile' | 'autoSpawn' | 'localOnly' | 'sampled':
                return "selected";
            case 'dataref' | 'groupref' | 'tilesheetActionRef' | 'tilesheetRef':
                return "text";
            case 'materialRefs':
                return 'dataSource';
            default:
                return "pos";
        }
    }
    inline static public function inferType(param:Dynamic):ArrayDataSource<Dynamic> {
        var ntt = new InspectorTypeTransformer();
        if(Std.is(param,Int) || Std.is(param,String) || Std.is(param,Bool) || Std.is(param,Float) ){
            return new ArrayDataSource<Dynamic>(ntt);
        }
        else{
            return new ArrayDataSource<Dynamic>();
        }
    }
}

@:build(haxe.ui.macros.ComponentMacros.build("haxe/ui/extended/custom/inspector-node.xml"))
class InspectorNode extends TreeNode {

    public function new(data:InspectorData = null,tv:TreeView = null) {
        super(data,tv);
        this.removeComponent(expander);
        //populate transform
        for(f in Reflect.fields(transform)){
            if(Reflect.hasField(data,f)){
                var temp = Reflect.field(transform,f);
                Reflect.setProperty(temp,Resolver.resolve(f),Reflect.field(data,f));
                Reflect.setProperty(transform,f,temp);
            }
        }
        //populate the rest
        for(f in Reflect.fields(data)){
            if(Reflect.hasField(this,f)){
                var temp = Reflect.field(this,f);
                var type = Resolver.resolve(f);
                if(type == 'dataSource'){
                    var value = Reflect.getProperty(data,f);
                    var ds = Resolver.inferType(value[0]);
                    for(v in value){
                        ds.add(v);
                        trace(ds.get(ds.size-1));
                    }
                    var feed = Reflect.field(temp,"feed");
                    Reflect.setProperty(feed,type,ds);
                    Reflect.setProperty(temp,"feed",feed);
                }
                else{
                    Reflect.setProperty(temp,type,Reflect.getProperty(data,f));
                }
                
                Reflect.setProperty(this,f,temp);
            }
        }
        ins_hbox.invalidateComponent();
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