package haxe.ui.extended;

import haxe.ui.data.DataSource;
import haxe.ui.containers.ScrollView;
import haxe.ui.components.Label;
import haxe.ui.containers.VBox;
import haxe.ui.events.UIEvent;
import haxe.ui.events.MouseEvent;
import haxe.ui.core.Component;

typedef TItem ={
    var name:String;
    var expands:Bool;
    var onClicked:MouseEvent->Void;
    var ?filter:String;
}

@:build(haxe.ui.macros.ComponentMacros.build(
    "haxe/ui/extended/custom/tree-ui.xml"))
class TreeView extends VBox {

    public var selectedNode:TreeNode = null;

    //To filter out specific nodes just add the names to this field
    public var filterNodes:Array<String> = [];
    public var dataSource(get,set):DataSource<NodeData>;
    public var minChilds:Int = 0;

    public var rclickItems:Array<TItem> = [];

    function get_dataSource(){
        return _dataSource;
    }
    function set_dataSource(ds:DataSource<NodeData>){
        _dataSource = ds;
        for( i in 0...ds.size){
            addNode(ds.get(i));
        }
        return _dataSource;
    }
    var _dataSource:DataSource<NodeData> = null;

    public function new() {
        super();
        percentWidth = 100.0;
        percentHeight = 100.0;
        var comp:Component = findComponent("scrollview-contents");
        comp.percentWidth = 100.0;
    }

    public function addNode(data:NodeData):Void {
        if(!filterOut(data.name)){
            var node  = new TreeNode(data,this);
            feed.addComponent(node);
        }
    }
    public function removeNode(data:NodeData):Void{
        var node = findNode(data.name);
        feed.removeComponent(node);

    }
    
    public function clear() {
        selectedNode = null;
        var contents:Component = findComponent("scrollview-contents");
        contents.removeAllComponents();
    }
    
    public function findNode(path:String):Component {
        var parts = path.split("/");
        var first = parts.shift();
        
        var node:Component = null;
        for (c in this.childComponents) {
            var label = c.findComponent(Label, true);
            if (label != null && label.text == first) {
                node = label.parentComponent.parentComponent;
                break;
            }
        }
        
        // if (parts.length > 0 && node != null) {
        //     node = node.findNode(parts.join("/"));
        // }
        
        return node;
    }
    public function filterOut(name:String):Bool{
        for( filter in filterNodes ){
            if(name == filter)
                return true;
        }
        return false;
    }
}