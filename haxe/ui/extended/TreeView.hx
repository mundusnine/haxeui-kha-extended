package haxe.ui.extended;

import haxe.ui.data.DataSource;
import haxe.ui.containers.ScrollView;
import haxe.ui.components.Label;
import haxe.ui.containers.VBox;
import haxe.ui.events.UIEvent;

@:build(haxe.ui.macros.ComponentMacros.build(
    "../Libraries/haxeui-kha-extended/haxe/ui/extended/custom/tree-ui.xml"))
class TreeView extends VBox {

    public var selectedNode:TreeNode = null;
    public var dataSource(get,set):DataSource<NodeData>;
    function get_dataSource(){
        return _dataSource;
    }
    function set_dataSource(ds:DataSource<NodeData>){
        _dataSource = ds;
        // clear();
        for( i in 0...ds.size){
            addNode(ds.get(i));
        }
        return _dataSource;
    }
    var _dataSource:DataSource<NodeData> = null;

    public function new() {
        super();
    }

    public function addNode(data:NodeData):TreeNode {
        var node  = new TreeNode(data,this);
        feed.addComponent(node);
       return node;
    }
    
    function clear() {
        selectedNode = null;
        feed.removeAllComponents();
    }
    
    public function findNode(path:String):TreeNode {
        var parts = path.split("/");
        var first = parts.shift();
        
        var node:TreeNode = null;
        for (c in this.childComponents) {
            var label = c.findComponent(Label, true);
            if (label != null && label.text == first) {
                node = cast(c, TreeNode);
                break;
            }
        }
        
        if (parts.length > 0 && node != null) {
            node = node.findNode(parts.join("/"));
        }
        
        return node;
    }
}