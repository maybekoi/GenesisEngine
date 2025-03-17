package ge;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import ge.ui.HUD;
import ge.game.objects.Ring;
import ge.game.objects.GoalPost;
import ge.ui.LevelCompleteUI;

class StageState extends FlxState {
    var map:FlxOgmo3Loader;
    var walls:FlxTilemap;
    var player:Dynamic;
    var engineText:FlxText;
    var hud:HUD;
    var camHUD:FlxCamera;
    var camGame:FlxCamera;
    var timeAccumulator:Float = 0;
    var rings:FlxTypedGroup<Ring>;
    var scatteredRings:FlxTypedGroup<Ring>;
    var currentLevel:Int = 1;
    var maxLevels:Int = 2;
    var goalPost:GoalPost;
    var levelCompleted:Bool = false;
    var levelCompleteUI:LevelCompleteUI;

    override public function create() {
        var selectedChar = Globals.selectedCharacter;
        
        if (Globals.currentLevel > 0) {
            currentLevel = Globals.currentLevel;
        }
        
        Globals.resetGameState();
        
        Globals.selectedCharacter = selectedChar;
        Globals.currentLevel = currentLevel;
        
        setupCameras();
        
        loadLevel();
        
        setupObjects();
        
        createPlayer();
        if (map != null) {
            map.loadEntities(placeEntities, "Entities");
        }
        add(player);
        
        if (player != null && walls != null) {
            camGame.follow(player, LOCKON);
            camGame.setScrollBoundsRect(0, 0, walls.width, walls.height);
        }
        
        setupHUD();
        
        super.create();
    }
    
    function setupCameras():Void {
        camGame = new FlxCamera();
        camHUD = new FlxCamera();
        camHUD.bgColor.alpha = 0;

        FlxG.cameras.reset(camGame);
        FlxG.cameras.add(camHUD);

        FlxCamera._defaultCameras = [camGame];
    }
    
    function loadLevel(mapPath:String = null, levelPath:String = null, tilesetPath:String = null, layerName:String = "Map"):Void {
        if (mapPath == null || levelPath == null || tilesetPath == null) {
            trace("Base loadLevel called - override or provide parameters");
            return;
        }
        
        map = new FlxOgmo3Loader(mapPath, levelPath);
        walls = map.loadTilemap(Util.getImage(tilesetPath), layerName);
        walls.follow();
        add(walls);        
    }
    
    function createPlayer():Void {}
    
    function setupHUD():Void {
        hud = new HUD();
        add(hud);
        hud.cameras = [camHUD];
    }
    
    function setupObjects():Void {
        rings = new FlxTypedGroup<Ring>();
        scatteredRings = new FlxTypedGroup<Ring>();
        
        if (map != null) {
            map.loadEntities(placeEntities, "Objects");
        }
        
        add(rings);
        add(scatteredRings);
        
        engineText = new FlxText(0, 0, 500);
        engineText.text = "Welcome to Genesis Engine!";
        engineText.setFormat("assets/fonts/vcr.ttf", 20, FlxColor.WHITE, CENTER);
        engineText.setBorderStyle(OUTLINE, FlxColor.BLUE, 1);
        add(engineText);
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);
        
        handleDebugControls();
        
        handleCollisions();
        
        updateTime(elapsed);
        
        FlxG.overlap(player, rings, collectRing);
        FlxG.overlap(player, scatteredRings, collectRing);
        
        FlxG.collide(scatteredRings, walls);
        
        checkLevelComplete();
    }
    
    function handleDebugControls():Void {
        if (FlxG.keys.justPressed.R) {
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
        
        if (FlxG.keys.justPressed.SEVEN) {
            loadNextLevel();
        }
    }
    
    function handleCollisions():Void {
        var prevY = player.y;
        
        if (FlxG.collide(player, walls)) {
            if (player.ySpeed >= 0) {
                player.isOnGround = true;
                player.ySpeed = 0;
                player.groundAngle = 0;
            } else {
                player.ySpeed = 0;
            }
        } else if (player.isOnGround && !FlxG.overlap(player, walls)) {
            player.isOnGround = false;
        }
    }
    
    function updateTime(elapsed:Float):Void {
        if (!Globals.timePaused) {
            timeAccumulator += elapsed;
            if (timeAccumulator >= 1.0) {
                Globals.time++;
                timeAccumulator -= 1.0;
            }
        }
    }
    
    function placeEntities(entity:EntityData):Void {
        if (entity.name == "Player") {
            player.setPosition(entity.x, entity.y);
        } else if (entity.name == "Ring" || entity.name == "Rings") {
            var ring = new Ring(entity.x, entity.y);
            rings.add(ring);
        } else if (entity.name == "GoalPost") {
            goalPost = new GoalPost(entity.x, entity.y + 95);
            add(goalPost);
        }
    }
    
    function collectRing(player:Dynamic, ring:Ring):Void {
        if (ring.animation.name == "collect") return;
        ring.collect();
    }
    
    function hitPlayer():Void {
        if (Globals.rings > 0) {
            var ringCount:Int = Std.int(Math.min(Globals.rings, 20));
            Globals.rings = 0;
            
            var newRings:Array<Ring> = Ring.scatterRings(player.x, player.y, ringCount);
            for (ring in newRings) {
                scatteredRings.add(ring);
            }
        } else {
            trace("we kill sonic.");
        }
    }
    
    function loadNextLevel():Void {
        currentLevel++;
        if (currentLevel > maxLevels) {
            currentLevel = 1;
        }
        
        var selectedChar = Globals.selectedCharacter;
        var rings = Globals.rings;
        var score = Globals.score;
        var lives = Globals.lives;
        
        Globals.currentLevel = currentLevel;
        
        var nextState = Type.createInstance(Type.getClass(this), []);
        
        Globals.selectedCharacter = selectedChar;
        Globals.rings = rings;
        Globals.score = score;
        Globals.lives = lives;
        
        FlxG.switchState(nextState);
    }
    
    function checkLevelComplete():Void {
        if (goalPost != null && !levelCompleted) {
            FlxG.overlap(player, goalPost, function(p, g) {
                if (!goalPost.triggered) {
                    goalPost.trigger();
                    levelCompleted = true;
                    
                    camGame.follow(null);
                    
                    Globals.timePaused = true;
                    
                    levelCompleteUI = new LevelCompleteUI(currentLevel);
                    add(levelCompleteUI);
                    levelCompleteUI.cameras = [camHUD];
                    
                    new flixel.util.FlxTimer().start(1.5, function(_) {
                        levelCompleteUI.show();
                        
                        new flixel.util.FlxTimer().start(6.0, function(_) {
                           // loadNextLevel();
                           // commented out cuz theres no level2 rn lol
                        });
                    });
                }
            });
        }
    }
}