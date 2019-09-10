package;

import haxe.ui.core.Component;
import haxe.ui.events.MouseEvent;
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.core.Screen;

@:build(haxe.ui.macros.ComponentMacros.build("../Assets/custom/file-browser-dialog.xml"))
class FileBrowserDialog extends Dialog {
    public function new(){
        super();
        title = "File Browser";
        modal = false;
        buttons =  DialogButton.APPLY | DialogButton.CANCEL;
		this.width = Screen.instance.width*0.95;
        this.height = Screen.instance.height*0.95;
    }

    public static function open(e:MouseEvent){
        var dialog = new FileBrowserDialog();
        Handler.updateData(dialog,"");
        dialog.show();
    }
}