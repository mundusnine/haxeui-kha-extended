package haxe.ui.extended;

import haxe.ui.data.DataSource;
import haxe.ui.containers.ScrollView;
import haxe.ui.components.Label;
import haxe.ui.events.UIEvent;
import haxe.ui.core.Component;
import haxe.ui.extended.InspectorNode;


class InspectorView extends TreeView {

    var curNode:InspectorNode = null;
    override function get_dataSource(){
        return i_dataSource;
    }
    override function set_dataSource(ds:DataSource<NodeData>){
        if(curNode != null)
            feed.removeComponent(curNode);
        i_dataSource = cast(ds);
        for( i in 0...i_dataSource.size){
            addNode(i_dataSource.get(i));
        }
        return i_dataSource;
    }
    var i_dataSource:DataSource<InspectorData> = null;

    public function new() {
        super();
    }
    public override function addNode(data:NodeData):Void {
        if(!filterOut(data.name)){
            curNode  = new InspectorNode(cast(data),this);
            feed.addComponent(curNode);
        }
    }
}
