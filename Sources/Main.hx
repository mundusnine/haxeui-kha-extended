package;

import kha.Assets;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

class Main {
	static var ui:UiManager;
	static function update(): Void {
		ui.update();
	}

	static function render(frames: Array<Framebuffer>): Void {
		ui.render(frames);
	}

	public static function main() {
		System.start({title: "Project", width: 1024, height: 768}, function (_) {
			// Just loading everything is ok for small projects
			Assets.loadEverything(function () {
				// Avoid passing update/render directly,
				// so replacing them via code injection works
				ui = new UiManager();
				Scheduler.addTimeTask(function () { update(); }, 0, 1 / 60);
				System.notifyOnFrames(function (frames) { render(frames); });
			});
		});
	}
	static function tupdate(): Void {

	}

	static function trender(frames: Array<Framebuffer>): Void {

	}

}
