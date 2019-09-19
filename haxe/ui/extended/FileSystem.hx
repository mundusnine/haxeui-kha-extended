package haxe.ui.extended;

class FileSystem {

    public static var dataPath = "";
    public static var curDir:String = "";
    public static var sep ="/";
	static var lastPath:String = "";
    static function initPath(systemId: String) {
		switch (systemId){
			case "Windows":
				return "C:\\Users";
			case "Linux":
				return "$HOME";
			default:
				return "/";
		}
		// %HOMEDRIVE% + %HomePath%
		// ~
	}
	static function fixPath(path:String,systemId:String){
		if (path == "") path = initPath(systemId);
		switch (systemId){
			case "Windows":
				return StringTools.replace(path, "/", "\\");
			case "Linux":
				if(path.charAt(0) == "~"){
					var temp = path.split('~');
					temp[0]="$HOME";
					path = temp.join("");
				}
				return path;
			default:
				return path;
		}
	}
    
	static public function exists(path:String){
		#if kha_krom
		var save = Krom.getFilesLocation() + sep + dataPath + "exists.txt";
		var systemId = kha.System.systemId;
		path = fixPath(path,systemId);
		var cmd = 'if [ -f "$path" ]; then\n\techo "true"\nelse\n\techo "false"\nfi > $save';
		if (systemId == "Windows") {
			// cmd = "dir /b ";
			// sep = "\\";
			// path = StringTools.replace(path, "\\\\", "\\");
			// path = StringTools.replace(path, "\r", "");
			return false;
		}
		Krom.sysCommand(cmd);
		var str = haxe.io.Bytes.ofData(Krom.loadBlob(save)).toString();
		return str == "true";
		#elseif kha_kore
		return sys.FileSystem.exists(path);
		#elseif kha_webgl
		return untyped require('fs').existsSync(path);
		#else
		return false;
		#end
	}
    static public function getFiles(path:String, folderOnly =false){

        #if kha_krom

		var cmd = "ls -F ";
		var systemId = kha.System.systemId;
		if (systemId == "Windows") {
			cmd = "dir /b ";
			if (folderOnly) cmd += "/ad ";
			sep = "\\";
			path = StringTools.replace(path, "\\\\", "\\");
			path = StringTools.replace(path, "\r", "");
		}
		path = fixPath(path,systemId);
		var save = Krom.getFilesLocation() + sep + dataPath + "dir.txt";
		if (path != lastPath) Krom.sysCommand(cmd + '"' + path + '"' + ' > ' + '"' + save + '"');
		lastPath = path;
		var str = haxe.io.Bytes.ofData(Krom.loadBlob(save)).toString();
		var files = str.split("\n");
		#elseif kha_kore

		path = fixPath(path,kha.System.systemId);
		if(StringTools.contains(path,"$HOME")){
			var home = new sys.io.Process("echo",["$HOME"]).stdout.readAll().toString();
			path = StringTools.replace(path,"$HOME",home);
		}
		var files = sys.FileSystem.isDirectory(path) ? sys.FileSystem.readDirectory(path) : [];

		#elseif kha_webgl

		var files:Array<String> = [];

		var userAgent = untyped navigator.userAgent.toLowerCase();
		if (userAgent.indexOf(' electron/') > -1) {
			var pp = untyped window.process.platform;
			var systemId = pp == "win32" ? "Windows" : (pp == "darwin" ? "OSX" : "Linux");
			try {
				path = fixPath(path,systemId);
				if(StringTools.contains(path,"$HOME")){
					var home = untyped process.env.HOME || process.env.HOMEPATH || process.env.USERPROFILE;
					path = StringTools.replace(path,"$HOME",home);
				}
				files = untyped require('fs').readdirSync(path);
			}
			catch(e:Dynamic) {
				// Non-directory item selected
			}
		}

		#else

		var files:Array<String> = [];

		#end
        curDir = path;
		if(folderOnly){
			return files.filter(function (e:String){
				return isDirectory(path+sep+e);
			});
		}
        return files;
    }

	public static function isDirectory(path:String):Bool {
		#if kha_krom
		return path.charAt(path.length)=="/";
		#elseif kha_kore
		return sys.FileSystem.isDirectory(path);
		#elseif kha_webgl
		return try untyped require('fs').statSync(path).isDirectory() catch (e:Dynamic) false;
		#else
		return false;
		#end
		
	}
	public static function createDirectory(path:String,onDone:Void->Void = null):Void {
		#if kha_krom
		var cmd = "mkdir";
		var systemId = kha.System.systemId;
		if (systemId == "Windows") {
			sep = "\\";
			path = StringTools.replace(path, "\\\\", "\\");
			path = StringTools.replace(path, "\r", "");
		}
		Krom.sysCommand(cmd + '"' + path + '"');
		if(onDone!= null)
			onDone();
		#elseif kha_kore
		sys.FileSystem.createDirectory(path);
		if(onDone!= null)
			onDone();
		#elseif kha_webgl
		try  untyped require('fs').mkdir(path,function(err){
			if(err) throw err;
			else if(onDone!= null)
				onDone();
		});
		#else
		throw "Target platform doesn't support creating a directory";
		#end
	}
	public static function saveToFile(path:String,data:haxe.io.Bytes,onDone:Void->Void = null){
		#if kha_krom
		Krom.fileSaveBytes(path,data.getData());
		if(onDone!= null)
			onDone();
		#elseif kha_kore
		sys.io.File.saveBytes(path,data);
		if(onDone!= null)
			onDone();
		#elseif kha_webgl
		untyped require('fs').writeFile(path,data,function (err){
			if(err) throw err;
			else if(onDone!= null)
				onDone();
		});
		#else
		throw "Target platform doesn't support saving data to files";
		#end
	}
}