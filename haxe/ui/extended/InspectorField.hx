package haxe.ui.extended;

import haxe.ui.containers.VBox;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import haxe.ui.data.DataSource;
import haxe.ui.core.ItemRenderer;
import haxe.ui.core.Component;
import haxe.ui.macros.ComponentMacros;
import haxe.ui.extended.TreeNode;
import haxe.ui.extended.TreeView.TItem;
import haxe.ui.data.*;

#if coin
import coineditor.InspectorTypeTransformer;
#else
import haxe.ui.extended.InspectorTypeTransformer;
#end


class InspectorField extends TreeNode {

    public var render:String =null;
    var _item:String = "ifield-string";
    public var item(get,set):String;
    public var hasChildren = false;
    public var tree:TreeView = null;
    public var rclickItems(default,set):Array<TItem> = [];
    function set_rclickItems(items:Array<TItem>){
        for(i in items){
            if(this.id == i.filter){
                rclickItems.push(i);
            }
        }
        return rclickItems;
    }
    function get_item(){
        return _item;
    }
    function set_item(value:String){
        if(rendrerers.exists(value)){
            _item = value;
        } else{
            trace('Item renderer $value is not defined in rendrerers');
        }
        return _item;
    }

    static var rendrerers:Map<String,Class<Dynamic>> =[
            "ifield-tparticle" => IfieldTparticle,
            "ifield-tlod" => IfieldTlod,
            "ifield-ttrait" => IfieldTtrait,
            "ifield-string" => IfieldString
        ];

    public function new(data:Dynamic = null, ptree:TreeView = null, pitem:String = null){

        if(pitem != null && this._item == "ifield-string"){
            this.item = pitem;
        }
            
        if(ptree == null)
            ptree = new TreeView();
        tree = ptree;
        tree.hide();

        var ndata:NodeData = {name:"",type:"",path:""};
        if(data != null){
            for(f in Reflect.fields(ndata)){
                if(Reflect.hasField(data,f)){
                    var value = Reflect.field(data,f);
                    Reflect.setProperty(ndata,f,value);
                    this.hasChildren = true;
                }
            }
        }
        else {
            if(text != null && text != ""){
                ndata.name = text;
            }
        }
        super(ndata,tree);

        var comp:Component = null;
        if(data != null && this.item != null){
            comp = Type.createInstance(rendrerers.get(this.item),[]);
            comp.marginLeft = 16;
            for(c in comp.childComponents[0].childComponents){
                for(field in Reflect.fields(data)){
                    if(c.id == field){
                        if(Std.is(c,InspectorField)){
                            var ifield:InspectorField = cast(c);
                            var values:Array<Dynamic> = Reflect.field(data,field);
                            ifield.tree = this.tree;
                            for(v in values){
                                ifield.addField(v);
                            }
                        }
                        else{
                            c.value = Reflect.field(data,field);
                        }
                    }
                }
            }
            this.addComponent(comp);
            expander.resource = "img/control-270-small.png";
        }
    
		this.percentWidth = 100.0;
        // name.registerEvent(MouseEvent.RIGHT_CLICK,addMenu);
        // expander.registerEvent(MouseEvent.RIGHT_CLICK,addMenu);
    }

    static var transformer:InspectorTypeTransformer = new InspectorTypeTransformer();
    public function addField(data:Dynamic){
        data = transformer.transformFrom(data);
        _expanded = true;
        this.hasChildren =true;
        expander.resource = "img/control-270-small.png";
        var newNode = new InspectorField(data,tree,this.render);
        newNode.marginLeft = 16;
        if(!newNode.hasChildren){
            newNode.removeComponent(newNode.u_node);
            newNode.removeComponent(newNode.expander);
        }
        newNode.parentNode = this;
        addComponent(newNode);
        return newNode;


    }

    // @:bind(u_node,MouseEvent.RIGHT_CLICK)
    // function addMenu(e:MouseEvent){
    //     trace("right_clicked");
    // }
}