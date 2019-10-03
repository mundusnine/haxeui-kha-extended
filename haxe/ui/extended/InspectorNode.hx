package haxe.ui.extended;

import haxe.ui.containers.VBox;
import haxe.ui.containers.HBox;
import haxe.ui.components.Label;
import haxe.ui.core.Component;
import haxe.ui.events.UIEvent;
import haxe.ui.events.MouseEvent;
import haxe.ui.extended.TreeNode;
import haxe.ui.extended.NodeData;
import haxe.ui.extended.InspectorField;
import haxe.ui.data.*;

import iron.data.SceneFormat;


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
            case 'materialRefs' | 'objectActions' | 'boneActions' | 'particleRefs' | 'lods' | 'traits' | 'parameters':
                return 'dataSource';
            default:
                return "pos";
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

        var ds = new ArrayDataSource<Dynamic>(new InspectorTypeTransformer());
        //populate the rest
        for(f in Reflect.fields(data)){
            if(Reflect.hasField(this,f)){
                var temp = Reflect.getProperty(this,f);
                var type = Resolver.resolve(f);
                if(type == 'dataSource'){
                    var value:Array<Dynamic> = Reflect.getProperty(data,f);
                    var comp:InspectorField = findComponent(f,InspectorField);
                    ds.clear();
                    if(comp.item != null)
                        comp.itemRenderer = comp.item;
                    
                    if(comp.text != null)
                        comp.name.text = comp.text;

                    for(v in value){
                        ds.add(v);
                        var ndata = ds.get(ds.size-1);
                        comp.addField(ndata,comp.itemRenderer);
                    }
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