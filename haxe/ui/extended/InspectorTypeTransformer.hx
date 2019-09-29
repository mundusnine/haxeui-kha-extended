package haxe.ui.extended;

import haxe.ui.data.transformation.IItemTransformer;

class InspectorTypeTransformer implements IItemTransformer<Dynamic> {
    public function new() {
    }

    public function transformFrom(i:Dynamic):Dynamic {
        var o:Dynamic = null;
        if (Std.is(i, String)) {
            o = { tfield: "field", text: i, value: i };
        } else if (Std.is(i, Int) || Std.is(i, Float) || Std.is(i, Bool)) {
            o = { value: i };
        } else {
            o = i;
        }
        return o;
    }

}