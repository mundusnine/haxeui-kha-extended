package haxe.ui.extended;

import haxe.ui.core.Component;
import haxe.ui.containers.VBox;
import haxe.ui.events.UIEvent;
import haxe.ui.data.ListDataSource;
import kha.FileSystem;

@:build(haxe.ui.macros.ComponentMacros.build(
	"haxe/ui/extended/custom/file-browser-ui.xml"))
class FileBrowser extends VBox {
    
	public var nofilepath(default,set) = true;
	function set_nofilepath(b:Bool) {
		if(nofilepath){
			feed.percentHeight = 93.0;
			filepath.percentHeight = 4.0;
			filepath.show();
		}
		return nofilepath = b;

	}
	public function new(){
        super();
		id = "filebrowser";
		feed.itemRenderer =  haxe.ui.macros.ComponentMacros.buildComponent(
			"haxe/ui/extended/custom/browser-items.xml");
		this.percentWidth = 100.0;
		this.percentHeight = 100.0;
		path.percentHeight = 3.0;
		filepath.hide();
		feed.percentHeight = 97.0;
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
				if(path == "")
					path = path += FileSystem.sep;
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
		filepath.text = folder.path;
	}
}