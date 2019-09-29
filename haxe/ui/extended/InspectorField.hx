package haxe.ui.extended;

import haxe.ui.containers.VBox;
import haxe.ui.events.MouseEvent;
import haxe.ui.data.DataSource;

@:build(haxe.ui.macros.ComponentMacros.build(
	"haxe/ui/extended/custom/inspector-field-ui.xml"))
class InspectorField extends VBox{

    private var _expanded:Bool = true;

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
        name.text = text; 
		feed.itemRenderer =  haxe.ui.macros.ComponentMacros.buildComponent(
			"haxe/ui/extended/custom/inspector-field-renderer.xml");
		this.percentWidth = 100.0;
        // this.percentHeight = 100.0;
    }

    //expander interactions
    @:bind(expander,MouseEvent.CLICK)
    function clicked(e:MouseEvent) {
        if (_expanded == false) {
            expander.resource = "img/control-270-small.png";
            _expanded = true;
            feed.show();
        } 
        else {
            expander.resource = "img/control-000-small.png";
            _expanded = false;
            feed.hide();
        }
    }
}