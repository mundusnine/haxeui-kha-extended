package haxe.ui.extended;

import haxe.ui.components.Label;
import haxe.ui.data.ListDataSource;
import haxe.ui.containers.ListView;
import haxe.ui.core.Component;

class Handler {
    static public function updateData(comp:Component,path:String, data:ListDataSource<NodeData> = null){
		var feed:ListView = comp.findComponent('feed',ListView);
        feed.dataSource = data != null ? data : getFilesData(path);
		var parPath:Label = comp.findComponent('path',Label);
		if(!parPath.disabled)
			parPath.text = path;

		FileSystem.curDir = path;
		var par:NodeData  = feed.dataSource.get(feed.dataSource.size-1);
		feed.dataSource.remove(par);
		comp.invalidateComponentLayout();
	}
    static public function getFilesData(path:String, folderOnly = false,count=0,recursive=false):ListDataSource<NodeData> {

        if(path=="")
            path = FileSystem.curDir;	
		var files = FileSystem.getFiles(path,folderOnly);
        var ds = new ListDataSource<NodeData>();
		ds.add({name: "..",path: "", type: ""});
        // Directory contents
		for (f in files) {
			if (f == "" || f.charAt(0) == ".") continue; // Skip hidden
            var p = path;
            if (path.charAt(path.length - 1) != FileSystem.sep) p += FileSystem.sep;
			if(f.split('.')[0] == f && count < 2){
				count = !recursive ? count+1:0;
            	ds.add({path:p+f,name: f, type: findType(p+f),childs: getFilesData(p+f,folderOnly,count,recursive) });
			}
			else {
				ds.add({path:p+f,name: f, type: findType(p+f)});
			}
		}
		ds.add({name: "",path: path, type: ""});
        return ds;
    }
    static function findType(path:String){
		var end = path.split('.');
		if( end[0] == path){
			return "img/folder.png";
		}
		switch (end[end.length-1]){
			case "png" | "jpeg" | "gif":
				return "img/picture_grey.png";
			case "wav"|"ogg"|"mp3":
				return "img/audio-file_grey.png";
			case "txt"|"h"|"hx"|"c"|"cpp"|"md"|"xml"|"json":
				return "img/file_grey.png";
			default:
				return "img/blank.png";
		}
	}
}