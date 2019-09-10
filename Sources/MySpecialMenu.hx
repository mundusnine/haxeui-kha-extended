package;
import haxe.ui.containers.menus.*;
import haxe.ui.core.Component;

@:build(haxe.ui.macros.ComponentMacros.build("../Assets/custom/myspecial-menu.xml"))
class MySpecialMenu extends Menu {
    public function new() {
        super();
        this.text="File";
        this.addComponent(new MenuItem()).text = "Item 1";
        this.addComponent(new MenuItem()).text = "Item 2";
        this.addComponent(new MenuItem()).text = "Item 3";
    }
}