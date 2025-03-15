package ge.states;

import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import ge.game.Sonic;
/*
import ge.game.Tails;
import ge.game.Knuckles;
*/
import flixel.tile.FlxTilemap;
import flixel.FlxG;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import ge.ui.HUD;
import flixel.FlxCamera;
import flixel.text.FlxText;

class PlayState extends FlxState
{
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var player:Dynamic;
	var engineText:FlxText;
	var hud:HUD;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	private var timeAccumulator:Float = 0;
	var livesText:FlxText;

	override public function create()
	{
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera._defaultCameras  = [camGame];

		trace("PlayState go brr!");
		map = new FlxOgmo3Loader("assets/data/maps.ogmo", "assets/data/levels/level1.json");
		walls = map.loadTilemap(Util.getImage("Sonic1_MD_Map_GHZ_blocks"), "Map");
		walls.follow();
		walls.setTileProperties(1, NONE);
		walls.setTileProperties(2, ANY);
		add(walls);

		createPlayer();
		map.loadEntities(placeEntities, "Entities");
		add(player);

		hud = new HUD();
		add(hud);

		hud.cameras = [camHUD];

		camGame.follow(player, LOCKON);
		camGame.setScrollBoundsRect(0, 0, walls.width, walls.height);
		camGame.zoom = 2.5;

		engineText = new FlxText(0, 0, 500);
		engineText.text = "Welcome to Genesis Engine!";
		engineText.setFormat("assets/fonts/vcr.ttf", 20, FlxColor.WHITE, CENTER);
		engineText.setBorderStyle(OUTLINE, FlxColor.BLUE, 1);
		add(engineText);
	
		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.R)
		{
			FlxG.resetState();
		}

		if (FlxG.keys.justPressed.ONE) {
			DebugFunctions.addLives(1);
		}

		if (FlxG.keys.justPressed.TWO) {
			DebugFunctions.addRings(5);
		}

		if (FlxG.keys.justPressed.THREE) {
			DebugFunctions.addScore(100);
		}
		
		var prevY = player.y;
		
		if (FlxG.collide(player, walls))
		{
			if (player.ySpeed >= 0)
			{
				player.isOnGround = true;
				player.ySpeed = 0;
				player.groundAngle = 0;
			}
			else
			{
				player.ySpeed = 0;
			}
		}
		else if (player.isOnGround && !FlxG.overlap(player, walls))
		{
			player.isOnGround = false;
		}

		timeAccumulator += elapsed;
		if (timeAccumulator >= 1.0) {
			Globals.time++;
			timeAccumulator -= 1.0;
		}
	}

	function createPlayer()
	{
		switch (Globals.selectedCharacter)
		{
			case 0: // Sonic
				player = new Sonic();
				// npc = new TailsNPC(player);
			case 1: // Sonic
				player = new Sonic();
			case 2: // Tails
				//player = new Tails();
			case 3: // Knuckles
				//player = new Knuckles();
			default:
				player = new Sonic();
		}
	}

	function placeEntities(entity:EntityData)
	{
		if (entity.name == "Player")
		{
			player.setPosition(entity.x, entity.y);
		}
	}
}
