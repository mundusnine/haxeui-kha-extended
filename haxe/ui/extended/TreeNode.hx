package haxe.ui.extended;

import haxe.ui.containers.VBox;
import haxe.ui.containers.HBox;
import haxe.ui.containers.menus.*;
import haxe.ui.components.Label;
import haxe.ui.core.Component;
import haxe.ui.core.Screen;
import haxe.ui.events.UIEvent;
import haxe.ui.events.MouseEvent;


@:build(haxe.ui.macros.ComponentMacros.build(
    "haxe/ui/extended/custom/tree-node-ui.xml"))
class TreeNode extends VBox {

    public var parentNode:TreeNode = null;
    public var data(default,never):NodeData;
    
    private var _expanded:Bool = false;
    private var _tv:TreeView = null;

    public function new(data:NodeData = null,tv:TreeView = null){
        super();
        percentWidth = _hbox.percentWidth = u_node.percentWidth = 100.0;
        _tv = tv;
        Reflect.setField(this,"data",data);
        name.text = data.name;
        type.resource = data.type;
        expander.resource = "img/blank.png";
        if(Reflect.hasField(data,"childs")){
            if(data.childs.size > _tv.minChilds){
                expander.resource = "img/control-000-small.png";
            }
        }
    }

    @:bind(u_node, MouseEvent.RIGHT_CLICK)
    function onRightclickcall(e:MouseEvent) {
        if(_tv.rclickItems.length == 0)return;
        selected(e);
        var menu = new Menu();
        for(i in _tv.rclickItems){
            var item = new MenuItem();
            item.text  = i.name;
            item.expandable = i.expands;
            item.onClick = i.onClicked;
            menu.addComponent(item);
        }
        menu.show();
        menu.left = e.screenX;
        menu.top = e.screenY;
        Screen.instance.addComponent(menu);
    }

    //_node interactions
    @:bind(u_node, MouseEvent.CLICK)
    function selected(e:UIEvent){
        
        var f = _tv.feed;
        if (_tv.selectedNode == this) {
            return;
        }
        
        if (_tv.selectedNode != null && _tv.selectedNode.findComponent("u_node") != null) {
            var comp:Component = _tv.selectedNode.findComponent("u_node");
            comp.removeClass(":selected");
            _tv.selectedNode = null;
        }
        u_node.addClass(":selected");
        _tv.selectedNode = this;
        
        var delta = (_tv.selectedNode.screenTop - f.screenTop + f.vscrollPos);
        // trace("vscrollpos: "+f.vscrollPos+" height: "+f.height);
        if (delta < f.vscrollPos || delta > f.height - 10) {
            delta -= _tv.selectedNode.height + 10;
            if (delta > f.vscrollMax) {
                delta = f.vscrollMax;
            }
            f.vscrollPos = delta;
        }
        
        _tv.dispatch(new UIEvent(UIEvent.CHANGE));
    }
    @:bind(u_node,MouseEvent.MOUSE_OVER)
    function onHover(e:MouseEvent){
        u_node.addClass(":hover");
    }
    @:bind(u_node,MouseEvent.MOUSE_OUT)
    function onOut(e:MouseEvent){
        u_node.removeClass(":hover");
    }

    //expander interactions
    @:bind(expander,MouseEvent.CLICK)
    function clicked(e:MouseEvent) {
        if (_expanded == false) {
            expander.resource = "img/control-270-small.png";
            _expanded = true;
        } 
        else {
            expander.resource = "img/control-000-small.png";
            _expanded = false;
        }
        
        // Add nodes on expanding
        if(childComponents.length == 1){
            if(Reflect.hasField(data,"childs")){
                if(data.childs.size > _tv.minChilds){
                    for(n in 0...data.childs.size){
                        var d = data.childs.get(n);
                        if(_tv.filterOut(d.name))
                            continue;
                        this.addNode(d);
                    }
                }
            }
        }

        for (c in childComponents) {
            if (c == _hbox) {
                continue;
            }
            
            if (_expanded == false) {
                c.hide();
            } else {
                c.show();
            }
        }

    }

    public var path(get, null):String;
    private function get_path():String {
        var ref = this;
        var parts:Array<String> = [];
        while (ref != null) {
            parts.push(ref.name.text);
            ref = ref.parentNode;
        }
        parts.reverse();
        return parts.join("/");
    }

    public override function get_text():String {
        if(name != null)
            return name.text;
        return "";
    }
    
    public override function set_text(value:String):String {
        super.set_text(value);
        if(name != null)
            name.text = value;
        return value;
    }
    
    public override function get_icon():String {
        return type.resource;
    }
    
    public override function set_icon(value:String):String {
        super.set_icon(value);
        type.resource = value;
        return value;
    }

    public function addNode(data:NodeData):TreeNode {
        
        _expanded = true;
        var newNode = new TreeNode(data,_tv);
        newNode.marginLeft = 16;
        newNode.parentNode = this;
        newNode.hide();
        addComponent(newNode);
        return newNode;
    }
    
    public function findNode(path:String):TreeNode {
        
        var parts = path.split("/");
        var first = parts.shift();
        
        var node:TreeNode = null;
        for (c in childComponents) {
            var label = c.findComponent(Label, true);
            if (label != null && label.text == first) {
                node = cast(c, TreeNode);
                break;
            }
        }
        
        if (parts.length > 0) {
            node = node.findNode(parts.join("/"));
        }
        
        return node;
    }

}