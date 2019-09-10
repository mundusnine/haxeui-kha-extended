package;

import haxe.ui.data.ListDataSource;

typedef FileData = {
    >NodeData,
}
typedef NodeData = {
	var path:String;
	var type:String;
	var name:String;
	var ?childs:ListDataSource<NodeData>;
}