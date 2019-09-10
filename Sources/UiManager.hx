package;

import haxe.ui.components.Button;
import haxe.ui.core.Component;
import haxe.ui.containers.menus.*;
import kha.Framebuffer;
import haxe.ui.core.Screen;
import haxe.ui.macros.ComponentMacros;
import haxe.ui.Toolkit;

class UiManager {
    var main:MainView;
    var dialog:FileBrowserDialog;
    public function new(){
        Toolkit.init();
        main = new MainView();
        var tab = new ProjectExplorer();
        // var menu  = new MySpecialMenu();
        var button = new Button();
        button.text = "button-test";
        button.onClick = FileBrowserDialog.open;
        main.addToContent(button);
        // main.bar.onClick = FileBrowserDialog.open;
        Screen.instance.addComponent(tab);

    }
    public function update(): Void {

    }

    public function render(framebuffers:Array<Framebuffer>): Void {
        var g = framebuffers[0].g2;
        g.begin(true, 0xFFFFFF);

        Screen.instance.renderTo(g);

        g.end();
    }
}