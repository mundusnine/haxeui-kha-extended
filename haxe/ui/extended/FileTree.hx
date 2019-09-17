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
		tree.dataSource = cast(Handler.getFilesData(fb.path.text,true,0,true));
		_brother = fb;
		return _brother;
	}
	public function new(){
        super();
		id = "filetree";
		path.disabled = true;
		path.text=" ";
		tree.filterNodes = ["..",""];
    }

    @:bind(tree, UIEvent.CHANGE)
	function selectedDir(e){
		var folder:NodeData = tree.selectedNode.data;
		if(folder.name.split('.')[0] == folder.name){
			var dataHolder = brother != null ? brother:this;
			Handler.updateData(dataHolder,folder.path);
			
		}
	}
}