package ge.states;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.text.FlxText;

class DataSelectState extends FlxState
{
	var saves:Int = 6;
	var saveSlots:Array<FlxSprite> = [];
	var saveImages:Array<FlxSprite> = [];
	var currentSelected:Int = 0;
	var targetX:Float = 0;
	var saveSlot:FlxSprite;
	var selector:FlxSprite;
	var arrows:FlxSprite;
	var selectorTimer:Float = 0;
	var arrowsTimer:Float = 0;
	var characters:Array<FlxSprite> = [];
	var currentCharacter:Int = 0;

	override public function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Util.getImage('datasel/dataSel_bg2'));
		bg.scrollFactor.set(0, 0);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = false;
		add(bg);

		for (i in 0...saves)
		{
			saveSlot = new FlxSprite(0, FlxG.height * 0.4);
			saveSlot.loadGraphic(Util.getImage('datasel/dataSel_saveBorder_S3_new'));
			saveSlots.push(saveSlot);
			saveSlot.scale.set(2.5, 2.5);			
			saveSlot.x = (FlxG.width * 0.5) + ((i - (saves / 2)) * 300);
			add(saveSlot);
		}

		selector = new FlxSprite(645, 273);
		selector.loadGraphic(Util.getImage('datasel/dataSel_selection_frame_s3'));
		selector.scale.set(2.5, 2.5);
		selector.screenCenter(Y);
		add(selector);
		
		arrows = new FlxSprite(674, 412);
		arrows.loadGraphic(Util.getImage('datasel/dataSel_arrows_character'));
		arrows.scale.set(2.5, 2.5);
		add(arrows);

		characters.push(new FlxSprite(669, 432));
		characters[0].loadGraphic(Util.getImage('datasel/SonicDS'));
		characters[0].scale.set(2.5, 2.5);
		characters[0].visible = true;
		add(characters[0]);

		characters.push(new FlxSprite(669, 432));
		characters[1].loadGraphic(Util.getImage('datasel/TailsDS'));
		characters[1].scale.set(2.5, 2.5);
		characters[1].visible = false;
		add(characters[1]);

		characters.push(new FlxSprite(669, 432));
		characters[2].loadGraphic(Util.getImage('datasel/KnucklesDS'));
		characters[2].scale.set(2.5, 2.5);
		characters[2].visible = false;
		add(characters[2]);

		var boarder:FlxSprite = new FlxSprite(-80).loadGraphic(Util.getImage('datasel/boarder'));
		boarder.scrollFactor.set(0, 0);
		boarder.updateHitbox();
		boarder.screenCenter();
		boarder.antialiasing = false;
		add(boarder);

		changeSelection();
	}	

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		#if debug
		// Debug camera controls
		if (FlxG.keys.pressed.I)
			FlxG.camera.scroll.y -= 500 * elapsed;
		if (FlxG.keys.pressed.K)
			FlxG.camera.scroll.y += 500 * elapsed;
		if (FlxG.keys.pressed.J)
			FlxG.camera.scroll.x -= 500 * elapsed;
		if (FlxG.keys.pressed.L)
			FlxG.camera.scroll.x += 500 * elapsed;
		#end

		if (FlxG.keys.justPressed.LEFT)
		{
			changeSelection(-1);
		}
		if (FlxG.keys.justPressed.RIGHT)
		{
			changeSelection(1);
		}
		if (FlxG.keys.justPressed.UP)
		{
			changeCharacter(-1);
		}
		if (FlxG.keys.justPressed.DOWN)
		{
			changeCharacter(1);
		}
		if (FlxG.keys.justPressed.BACKSPACE || FlxG.keys.justPressed.ESCAPE)
		{
			FlxG.switchState(new ge.states.TitleState());
		}
		if (FlxG.keys.justPressed.ENTER)
		{
			FlxG.switchState(new ge.states.PlayState());
		}

		if (FlxG.keys.justPressed.ONE)
		{
			trace("char X: " + characters[currentCharacter].x + " char Y: " + characters[currentCharacter].y);
		}

		selectorTimer += elapsed;
		if (selectorTimer >= 0.1)
		{
			selectorTimer = 0;
			selector.visible = !selector.visible;
		}

		arrowsTimer += elapsed;
		if (arrowsTimer >= 0.5)
		{
			arrowsTimer = 0;
			arrows.visible = !arrows.visible;
		}

		for (i in 0...saves)
		{
			var slot = saveSlots[i];
			var image = saveImages[i];
			var targetX = (FlxG.width * 0.5) + ((i - currentSelected) * 300);
			slot.x = FlxMath.lerp(slot.x, targetX, 0.16);
		}
	}

	function changeCharacter(change:Int = 0)
	{
		if (characters.length == 0) return;
		
		characters[currentCharacter].visible = false;
		currentCharacter += change;
		
		if (currentCharacter >= characters.length)
			currentCharacter = 0;
		if (currentCharacter < 0)
			currentCharacter = characters.length - 1;
		
		characters[currentCharacter].visible = true;
	}

	function changeSelection(change:Int = 0)
	{
		currentSelected += change;

		if (currentSelected >= saves)
			currentSelected = 0;
		if (currentSelected < 0)
			currentSelected = saves - 1;
	}
}