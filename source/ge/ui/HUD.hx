package ge.ui;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

using StringTools;

class HUD extends FlxSpriteGroup {
	var scoreText:FlxText;
	var timeText:FlxText;
	var ringsText:FlxText;
	var livesText:FlxText;
	var livesIcon:FlxSprite;

	var scoreCounterText:FlxText;
	var timeCounterText:FlxText;
	var ringsCounterText:FlxText;

	public function new() {
		super();

		scoreText = new FlxText(16, 8, 0, "SCORE", 16);
		scoreText.setFormat("assets/fonts/sonic-1-hud-font.ttf", 48, FlxColor.YELLOW, LEFT);
		scoreText.scrollFactor.set(0, 0);
		add(scoreText);

		scoreCounterText = new FlxText(16, 8, 0, "            0", 16);
		scoreCounterText.setFormat("assets/fonts/sonic-1-hud-font.ttf", 48, FlxColor.WHITE, LEFT);
		scoreCounterText.scrollFactor.set(0, 0);
		add(scoreCounterText);

		timeText = new FlxText(16, 48, 0, "TIME", 16);
		timeText.setFormat("assets/fonts/sonic-1-hud-font.ttf", 48, FlxColor.YELLOW, LEFT);
		timeText.scrollFactor.set(0, 0);
		add(timeText);

		timeCounterText = new FlxText(16, 48, 0, "            0:00", 16);
		timeCounterText.setFormat("assets/fonts/sonic-1-hud-font.ttf", 48, FlxColor.WHITE, LEFT);
		timeCounterText.scrollFactor.set(0, 0);
		add(timeCounterText);

		ringsText = new FlxText(16, 88, 0, "RINGS", 16);
		ringsText.setFormat("assets/fonts/sonic-1-hud-font.ttf", 48, FlxColor.YELLOW, LEFT);
		ringsText.scrollFactor.set(0, 0);
		add(ringsText);

		ringsCounterText = new FlxText(16, 88, 0, "            0", 16);
		ringsCounterText.setFormat("assets/fonts/sonic-1-hud-font.ttf", 48, FlxColor.WHITE, LEFT);
		ringsCounterText.scrollFactor.set(0, 0);
		add(ringsCounterText);

		livesIcon = new FlxSprite(50, 667, Util.getImage("ui/lives_sonic"));
		livesIcon.scrollFactor.set(0, 0);
		livesIcon.scale.set(2.5, 2.5);
		add(livesIcon);

		livesText = new FlxText(55, 676, 0, "3", 16);
		livesText.setFormat("assets/fonts/sonic-1-life-hud.ttf", 12, FlxColor.WHITE, LEFT);
		livesText.scrollFactor.set(0, 0);
		add(livesText);	
	}

	override public function update(elapsed:Float) {
		updateText();	
		super.update(elapsed);
	}

	public function updateText() {
		scoreCounterText.text = "            " + Globals.score;
		timeCounterText.text = "            " + formatTime(Globals.time);
		ringsCounterText.text = "            " + Globals.rings;
		livesText.text = "            " + Globals.lives;
	}

	public function formatTime(time:Int) {
		var minutes = Math.floor(time / 60);
		var seconds = time % 60;
		return StringTools.lpad(Std.string(minutes), "0", 1) + ":" + StringTools.lpad(Std.string(seconds), "0", 2);
	}
}