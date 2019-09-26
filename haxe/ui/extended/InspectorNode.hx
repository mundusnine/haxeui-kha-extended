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
} 

@:build(haxe.ui.macros.ComponentMacros.build("haxe/ui/extended/custom/inspector-node.xml"))
class InspectorNode extends TreeNode {

    public function new(data:InspectorData = null,tv:TreeView = null) {
        super(data,tv);
        dataref.text = data.dataref;
        transform.px.step = data.px;
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