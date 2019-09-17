package haxe.ui.extended;

import haxe.ui.core.Component;
import haxe.ui.containers.VBox;
import haxe.ui.events.UIEvent;
import haxe.ui.data.ListDataSource;

@:build(haxe.ui.macros.ComponentMacros.build(
	"haxe/ui/extended/custom/file-browser-ui.xml"))
class FileBrowser extends VBox {
    
	public function new(){
        super();
		id = "filebrowser";
		feed.itemRenderer =  haxe.ui.macros.ComponentMacros.buildComponent(
			"haxe/ui/extended/custom/browser-items.xml");
		this.percentWidth = 100.0;
        this.percentHeight = 100.0;
    }
	
    @:bind(feed, UIEvent.CHANGE)
	function selectedDir(e){
		var folder:NodeData = feed.selectedItem;
		if(folder.name == ".."){
			var path = FileSystem.curDir;
			var i1 = path.indexOf("/");
			var i2 = path.indexOf("\\");
			var nested =
				(i1 > -1 && path.length - 1 > i1) ||
				(i2 > -1 && path.length - 1 > i2);
			if (nested) {
				path = path.substring(0, path.lastIndexOf(FileSystem.sep));
				// Drive root
				if (path.length == 2 && path.charAt(1) == ":") path += FileSystem.sep;
			}
			Handler.updateData(this,path);

		}
		else if(folder.name.split('.')[0] == folder.name){
			if(Reflect.hasField(folder,"childs")){
				Handler.updateData(this,folder.path,folder.childs);
			}
			else {
				Handler.updateData(this,folder.path);
			}
		}
	}
}