package ge.game;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;

class Sonic extends FlxSprite
{
	private static inline var JUMP_FORCE:Float = 6.5;
	private static inline var PUSH_RADIUS:Float = 10;
	
	private static inline var ACCELERATION_SPEED:Float = 0.046875;
	private static inline var DECELERATION_SPEED:Float = 0.5;
	private static inline var FRICTION_SPEED:Float = 0.046875;
	private static inline var TOP_SPEED:Float = 6.0;
	
	private static inline var STANDING_WIDTH_RADIUS:Float = 9;
	private static inline var STANDING_HEIGHT_RADIUS:Float = 19;
	private static inline var ROLLING_WIDTH_RADIUS:Float = 7;
	private static inline var ROLLING_HEIGHT_RADIUS:Float = 14;
	private static inline var HITBOX_WIDTH_RADIUS:Float = 8;

	private static inline var GRAVITY_FORCE:Float = 0.21875;
	private static inline var JUMP_RELEASE_SPEED:Float = -4.0;
	
	private static inline var AIR_ACCELERATION_SPEED:Float = 0.09375;
	private static inline var AIR_DRAG_THRESHOLD:Float = -4.0;
	private static inline var GROUND_ANGLE_RESET_SPEED:Float = 0.049087;
	
	private var groundSpeed:Float = 0;
	public var ySpeed:Float = 0;
	private var isJumping:Bool = false;
	public var groundAngle:Float = 0;
	public var isOnGround:Bool = false;
	private var controlLockTimer:Float = 0;
	private var lastFacingRight:Bool = true;

	public function new()
	{
		super();
		
		loadGraphic("assets/images/Sonic.png", true); 
		frames = FlxAtlasFrames.fromSparrow("assets/images/Sonic.png", "assets/images/Sonic.xml");
		
		animation.addByPrefix("idle", "idle", 24, true);
		animation.addByPrefix("walk", "walk", 24, true);
		animation.addByPrefix("run", "run", 24, true);
		animation.addByPrefix("roll", "roll", 24, true);
		
		animation.play("idle");	
        
        setSize(STANDING_WIDTH_RADIUS * 2 + 1, STANDING_HEIGHT_RADIUS * 2 + 1);
        offset.set(width / 2, height / 4);
	}


	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (isOnGround)
		{
			handleGroundMovement();
			
			if (FlxG.keys.justPressed.Z || FlxG.keys.justPressed.X)
			{
				isJumping = true;
				isOnGround = false;
				
				groundSpeed -= JUMP_FORCE * Math.sin(groundAngle);
				ySpeed = -JUMP_FORCE * Math.cos(groundAngle);
			}
		}
		else
		{
			handleAirMovement();
			
			if (isJumping && !FlxG.keys.pressed.Z && !FlxG.keys.pressed.X && ySpeed < JUMP_RELEASE_SPEED)
			{
				ySpeed = JUMP_RELEASE_SPEED;
			}
			
			if (groundAngle != 0)
			{
				if (groundAngle > 0)
				{
					groundAngle = Math.max(0, groundAngle - GROUND_ANGLE_RESET_SPEED);
				}
				else
				{
					groundAngle = Math.min(0, groundAngle + GROUND_ANGLE_RESET_SPEED);
				}
			}
		}
		
		if (!isOnGround)
		{
			if (ySpeed < 0 && ySpeed > AIR_DRAG_THRESHOLD)
			{
				groundSpeed -= ((groundSpeed / 0.125) / 256);
			}
			
			ySpeed += GRAVITY_FORCE;
			
			// SCD Speed Cap:
			// if (ySpeed > 16) ySpeed = 16;
		}
		
		x += groundSpeed;
		y += ySpeed;
		
		updateAnim();
	}
	
	private function handleGroundMovement():Void
	{
		if (controlLockTimer > 0)
		{
			controlLockTimer -= FlxG.elapsed;
			if (!FlxG.keys.pressed.LEFT && !FlxG.keys.pressed.RIGHT)
			{
				applyFriction();
			}
			return;
		}
		
		if (FlxG.keys.pressed.LEFT)
		{
			if (groundSpeed > 0) 
			{
				groundSpeed -= DECELERATION_SPEED;
				if (groundSpeed <= 0)
					groundSpeed = -0.5;
			}
			else if (groundSpeed > -TOP_SPEED)
			{
				groundSpeed -= ACCELERATION_SPEED;
				if (groundSpeed <= -TOP_SPEED)
					groundSpeed = -TOP_SPEED;
			}
		}
		
		if (FlxG.keys.pressed.RIGHT)
		{
			if (groundSpeed < 0)
			{
				groundSpeed += DECELERATION_SPEED;
				if (groundSpeed >= 0)
					groundSpeed = 0.5;
			}
			else if (groundSpeed < TOP_SPEED)
			{
				groundSpeed += ACCELERATION_SPEED;
				if (groundSpeed >= TOP_SPEED)
					groundSpeed = TOP_SPEED;
			}
		}
		
		if (!FlxG.keys.pressed.LEFT && !FlxG.keys.pressed.RIGHT)
		{
			applyFriction();
		}
	}
	
	private function applyFriction():Void
	{
		var frictionToApply = Math.min(Math.abs(groundSpeed), FRICTION_SPEED) * (groundSpeed > 0 ? -1 : 1);
		groundSpeed += frictionToApply;
		
		if ((groundSpeed > 0 && groundSpeed + frictionToApply < 0) || 
			(groundSpeed < 0 && groundSpeed + frictionToApply > 0))
		{
			groundSpeed = 0;
		}
	}
	
	private function updateAnim():Void
	{
		if (!isOnGround)
		{
			animation.play("roll"); 
			return;
		}
		
		var absSpeed = Math.abs(groundSpeed);
		if (absSpeed < 0.1)
		{
			animation.play("idle");
			flipX = !lastFacingRight;
		}
		else if (absSpeed < 4)
		{
			animation.play("walk");
			lastFacingRight = (groundSpeed > 0);
			flipX = !lastFacingRight;
		}
		else
		{
			animation.play("run");
			lastFacingRight = (groundSpeed > 0);
			flipX = !lastFacingRight;
		}
	}
	
	private function handleAirMovement():Void
	{
		if (FlxG.keys.pressed.LEFT)
		{
			groundSpeed -= AIR_ACCELERATION_SPEED;
			if (groundSpeed < -TOP_SPEED)
				groundSpeed = -TOP_SPEED;
		}
		
		if (FlxG.keys.pressed.RIGHT)
		{
			groundSpeed += AIR_ACCELERATION_SPEED;
			if (groundSpeed > TOP_SPEED)
				groundSpeed = TOP_SPEED;
		}
	}
}