package haxe.ui.extended;

import haxe.ui.core.Component;
import haxe.ui.containers.VBox;
import haxe.ui.events.UIEvent;

@:build(haxe.ui.macros.ComponentMacros.build(
	"haxe/ui/extended/custom/file-tree-ui.xml"))
class FileTree extends VBox {
    
    var _brother:FileBrowser = null;
	public var brother(get,set):FileBrowser;
	function get_brother(){
		return _brother;
	}
	function set_brother(fb:FileBrowser){
		tree.dataSource = cast(fb.feed.dataSource);
		_brother = fb;
		return _brother;
	}
	public function new(){
        super();
		id = "filetree";
		path.disabled = true;
		path.text=" ";
    }

    @:bind(tree, UIEvent.CHANGE)
	function selectedDir(e){
		var folder:NodeData = tree.selectedNode.data;
        var dataHolder = brother != null ? brother:this;
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
			Handler.updateData(dataHolder,path);

		}
		else if(folder.name.split('.')[0] == folder.name){
			if(Reflect.hasField(folder,"childs")){
				Handler.updateData(dataHolder,folder.path,folder.childs);
			}
		}
	}
}