package haxe.ui.extended;

import haxe.ui.containers.VBox;
import haxe.ui.containers.HBox;
import haxe.ui.components.Label;
import haxe.ui.core.Component;
import haxe.ui.events.UIEvent;
import haxe.ui.events.MouseEvent;
import haxe.ui.extended.TreeNode;
import haxe.ui.extended.NodeData;


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
    var isParticle:Bool;
    var visible:Bool;
    var visibleMesh:Bool;
    var visibleShadow:Bool;
    var mobile:Bool;
    var autoSpawn:Bool;
    var localOnly:Bool;
    var sampled:Bool;

    
    
} 

@:build(haxe.ui.macros.ComponentMacros.build("haxe/ui/extended/custom/inspector-node.xml"))
class InspectorNode extends TreeNode {

    public function new(data:InspectorData = null,tv:TreeView = null) {
        super(data,tv);
        this.removeComponent(expander);
        dataref.text = data.dataref;
        transform.px.text = Std.string(data.px);
        transform.py.text = Std.string(data.py);
        transform.pz.text = Std.string(data.pz);
        transform.rx.text = Std.string(data.rx);
        transform.ry.text = Std.string(data.ry);
        transform.rz.text = Std.string(data.rz);
        transform.sx.text = Std.string(data.sx);
        transform.sy.text = Std.string(data.sy);
        transform.sz.text = Std.string(data.sz);
        isParticle.selected = data.isParticle;
        visible.selected = data.visible;
        trace("is visible:"+visible.selected); 
        visibleMesh.selected = data.visibleMesh;
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