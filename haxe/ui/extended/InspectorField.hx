package haxe.ui.extended;

import haxe.ui.containers.VBox;
import haxe.ui.events.MouseEvent;
import haxe.ui.events.UIEvent;
import haxe.ui.data.DataSource;
import haxe.ui.core.ItemRenderer;
import haxe.ui.macros.ComponentMacros;

@:build(haxe.ui.macros.ComponentMacros.build(
	"haxe/ui/extended/custom/inspector-field-ui.xml"))
class InspectorField extends VBox{

    private var _expanded:Bool = true;
    public var item:String = null;
    public var itemRenderer(get,set):String;
    function get_itemRenderer(){
        return item;
    }
    function set_itemRenderer(value:String){
        if(rendrerers.exists(value)){
            feed.itemRenderer = rendrerers.get(value);
            item = value;
        } else{
            trace('Item renderer $value is not defined in rendrerers');
        }
        return value;
    }

    static var rendrerers:Map<String,ItemRenderer> = null;

    public var dataSource(get,set):DataSource<Dynamic>;
    function get_dataSource(){
        return feed.dataSource;
    }
    function set_dataSource(ds:DataSource<Dynamic>){
        feed.dataSource = ds;
        return feed.dataSource;
    }

    public function new(){
        super();
        if(rendrerers == null){
            rendrerers = [
                "ifield-tparticle" => ComponentMacros.buildComponent("haxe/ui/extended/custom/ifield-tparticle.xml"),
                "ifield-tlod" => ComponentMacros.buildComponent("haxe/ui/extended/custom/ifield-tlod.xml"),
                "ifield-ttrait" => ComponentMacros.buildComponent("haxe/ui/extended/custom/ifield-ttrait.xml")
            ];
        }
		feed.itemRenderer =  haxe.ui.macros.ComponentMacros.buildComponent(
			"haxe/ui/extended/custom/ifield-string.xml");
		this.percentWidth = 100.0;
        name.registerEvent(MouseEvent.RIGHT_CLICK,addMenu);
        expander.registerEvent(MouseEvent.RIGHT_CLICK,addMenu);
    }

    //expander interactions
    @:bind(expander,MouseEvent.CLICK)
    function clicked(e:MouseEvent) {
        if (_expanded == false && feed.dataSource.size > 0) {
            expander.resource = "img/control-270-small.png";
            _expanded = true;
            feed.show();
        } 
        else if(_expanded && feed.dataSource.size > 0){
            expander.resource = "img/control-000-small.png";
            _expanded = false;
            feed.hide();
        }
    }
    @:bind(feed,UIEvent.CHANGE)
    function changed(e:UIEvent){
        if(e.data != null && Std.is(e.data,String) && e.data == "init"){
            if(feed.dataSource ==null || feed.dataSource.size == 0){
                _expanded =false;
                expander.hide();
                feed.hide();
            }
        }
    }
    @:bind(container,MouseEvent.RIGHT_CLICK)
    function addMenu(e:MouseEvent){
        trace("right_clicked");
    }
}