package haxe.ui.extended;

import haxe.ui.containers.VBox;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import haxe.ui.data.DataSource;
import haxe.ui.core.ItemRenderer;
import haxe.ui.core.Component;
import haxe.ui.macros.ComponentMacros;
import haxe.ui.extended.TreeNode;
import haxe.ui.data.*;

// @:build(haxe.ui.macros.ComponentMacros.build(
// 	"haxe/ui/extended/custom/inspector-field-ui.xml"))
class InspectorField extends TreeNode {

    // private var _expanded:Bool = true;
    public var item:String = null;
    public var itemRenderer(get,set):String;
    public var hasChildren = false;
    public var tree:TreeView = null;
    function get_itemRenderer(){
        return item;
    }
    function set_itemRenderer(value:String){
        if(rendrerers.exists(value)){
            item = value;
        } else{
            trace('Item renderer $value is not defined in rendrerers');
        }
        return value;
    }
    public function getType(){
        return rendrerers.get(item);
    }

    static var rendrerers:Map<String,Class<Dynamic>> =[
            "ifield-tparticle" => IfieldTparticle,
            "ifield-tlod" => IfieldTlod,
            "ifield-ttrait" => IfieldTtrait,
            "ifield-string" => IfieldString
        ];
    public var dataSource(get,set):DataSource<Dynamic>;
    function get_dataSource(){
        return _dataSource;
    }
    function set_dataSource(ds:DataSource<Dynamic>){
        _dataSource = ds;
        return _dataSource;
    }
    private var _dataSource:DataSource<Dynamic> = null;

    public function new(data:Dynamic = null, ptree:TreeView = null, item:String = null){

        if(item != null && this.item == null){
            this.item = item;
        }
        else{
            this.item = "ifield-string";
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
                            var value:Array<Dynamic> = Reflect.field(data,field);
                            var ds = new ArrayDataSource<Dynamic>(new InspectorTypeTransformer());
                            ifield.tree = this.tree;
                            for(v in value){
                                ds.add(v);
                                var ndata = ds.get(ds.size-1);
                                ifield.addField(ndata);
                            }
                            trace(ifield.id+":"+ifield.hasChildren);
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

    public function addField(data:Dynamic,item:String =null){
        _expanded = true;
        this.hasChildren =true;
        expander.resource = "img/control-270-small.png";
        var newNode = new InspectorField(data,tree,item);
        newNode.marginLeft = 16;
        if(!newNode.hasChildren){
            trace(newNode.text);
            newNode.removeComponent(newNode.node);
            newNode.removeComponent(newNode.expander);
        }
        newNode.parentNode = this;
        addComponent(newNode);
        return newNode;


    }

    // @:bind(node,MouseEvent.RIGHT_CLICK)
    // function addMenu(e:MouseEvent){
    //     trace("right_clicked");
    // }
}