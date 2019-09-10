package;

import haxe.ui.core.Component;
import haxe.ui.containers.menus.*;
import haxe.ui.containers.TabView;
import haxe.ui.events.MouseEvent;

@:build(haxe.ui.macros.ComponentMacros.build("../Assets/custom/editor-tab.xml"))
class EditorTab extends Component {

    public function new(){
        super();
        this.tabs.height = 100;
        this.tabs.width = 100;
    }
    
    @:bind(tabs,MouseEvent.RIGHT_CLICK)
    function onRightclickcall(e:MouseEvent) {
        var menu = new Menu();
        trace("was called");
    }
}