package haxe.ui.extended;

import haxe.ui.data.DataSource;
import haxe.ui.containers.ScrollView;
import haxe.ui.components.Label;
import haxe.ui.components.Button;
import haxe.ui.events.UIEvent;
import haxe.ui.events.MouseEvent;
import haxe.ui.core.Component;
import haxe.ui.extended.InspectorNode;


class InspectorView extends TreeView {

    public var updateData:UIEvent->Void = null;
    public var curNode:InspectorNode = null;
    public var initFields:Map<String,Component->Void> = new Map<String,Component->Void>();
    public var buttonsClick:Map<String,MouseEvent->Void> = new Map<String,MouseEvent->Void>();
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
            curNode  = new InspectorNode(cast(data),this,updateData);
            feed.addComponent(curNode);
            for(fname in initFields.keys()){
                var comp = curNode.findComponent(fname);
                if(comp != null){
                    initFields.get(fname)(comp);
                }
            }
            for(bname in buttonsClick.keys()){
                var butt:Button = curNode.findComponent(bname,Button);
                if(butt != null){
                    butt.onClick = buttonsClick.get(bname);
                }
            }
        }
    }
}
