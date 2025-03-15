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
	
	private static inline var ROLL_FRICTION_SPEED:Float = 0.0234375;
	private static inline var ROLL_DECELERATION_SPEED:Float = 0.125;
	private static inline var ROLL_SPEED_MIN:Float = 0.5;
	private static inline var ROLL_SPEED_FORCE:Float = 2.0;
	private static inline var ROLL_TOP_SPEED:Float = 16.0;
	
	private var groundSpeed:Float = 0;
	public var ySpeed:Float = 0;
	private var isJumping:Bool = false;
	public var groundAngle:Float = 0;
	public var isOnGround:Bool = false;
	private var controlLockTimer:Float = 0;
	private var lastFacingRight:Bool = true;
	private var isRolling:Bool = false;

	private static inline var SPINDASH_INITIAL_SPEED:Float = 8.0;
	private static inline var SPINDASH_MAX_CHARGE:Float = 8.0;
	private static inline var SPINDASH_CHARGE_INCREMENT:Float = 2.0;
	
	private static inline var SPINDASH_CD_CHARGE_TIME:Float = 45.0;
	private static inline var SPINDASH_CD_SPEED:Float = 12.0;
	
	private var isSpindashing:Bool = false;
	private var spinrev:Float = 0.0;
	private var spindashChargeTimer:Float = 0.0;
	private var spindashReleased:Bool = false;
	private var crouching:Bool = false;

	private static inline var DROP_DASH_SPEED:Float = 8.0;
	private static inline var DROP_DASH_MAX_SPEED:Float = 12.0;
	private static inline var DROP_DASH_CHARGE_TIME:Float = 20.0;
	
	private var isDropDashing:Bool = false;
	private var dropDashCharging:Bool = false;
	private var dropDashChargeTimer:Float = 0.0;
	private var dropDashDirection:Int = 1;

	public function new()
	{
		super();
		
		loadGraphic("assets/images/Sonic.png", true); 
		frames = FlxAtlasFrames.fromSparrow("assets/images/Sonic.png", "assets/images/Sonic.xml");
		
		animation.addByPrefix("idle", "idle", 24, true);
		animation.addByPrefix("walk", "walk", 24, true);
		animation.addByPrefix("run", "run", 24, true);
		animation.addByPrefix("roll", "roll", 24, true);
		animation.addByPrefix("spindash", "spindash", 24, true);
		animation.addByPrefix("down", "down", 24, true);
		
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
			
			if (isDropDashing)
			{
				var wasMovingBackwards = (groundSpeed > 0 && !lastFacingRight) || 
									   (groundSpeed < 0 && lastFacingRight);
				
				if (groundAngle == 0 && wasMovingBackwards)
				{
					groundSpeed = DROP_DASH_SPEED * dropDashDirection;
				}
				else
				{
					var speedDivisor = wasMovingBackwards ? 2.0 : 4.0;
					var newSpeed = (groundSpeed / speedDivisor) + (DROP_DASH_SPEED * dropDashDirection);
					
					if (Math.abs(newSpeed) > DROP_DASH_MAX_SPEED)
					{
						newSpeed = DROP_DASH_MAX_SPEED * (newSpeed > 0 ? 1 : -1);
					}
					
					groundSpeed = newSpeed;
				}
				
				isDropDashing = false;
				isRolling = true;
				setSize(ROLLING_WIDTH_RADIUS * 2 + 1, ROLLING_HEIGHT_RADIUS * 2 + 1);
			}
			
			if ((FlxG.keys.justPressed.Z || FlxG.keys.justPressed.X) && !isSpindashing)
			{
				isJumping = true;
				isOnGround = false;
				isRolling = false;
				setSize(STANDING_WIDTH_RADIUS * 2 + 1, STANDING_HEIGHT_RADIUS * 2 + 1);
				
				groundSpeed -= JUMP_FORCE * Math.sin(groundAngle);
				ySpeed = -JUMP_FORCE * Math.cos(groundAngle);
			}
		}
		else
		{
			handleAirMovement();
			
			if (Globals.dropDashActive && isJumping)
			{
				if ((FlxG.keys.justPressed.Z || FlxG.keys.justPressed.X) && ySpeed < 0)
				{
					dropDashCharging = true;
					dropDashChargeTimer = 0;
				}
				else if (dropDashCharging)
				{
					if (FlxG.keys.pressed.Z || FlxG.keys.pressed.X)
					{
						dropDashChargeTimer++;
						if (dropDashChargeTimer >= DROP_DASH_CHARGE_TIME)
						{
							isDropDashing = true;
							if (FlxG.keys.pressed.LEFT)
							{
								dropDashDirection = -1;
								lastFacingRight = false;
							}
							else if (FlxG.keys.pressed.RIGHT)
							{
								dropDashDirection = 1;
								lastFacingRight = true;
							}
							else
							{
								dropDashDirection = lastFacingRight ? 1 : -1;
							}
						}
					}
					else
					{
						dropDashCharging = false;
						isDropDashing = false;
					}
				}
			}
			
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
				if (isRolling)
					applyRollFriction();
				else
					applyFriction();
			}
			return;
		}
		
		if (FlxG.keys.pressed.DOWN)
		{
			crouching = true;
			if (Math.abs(groundSpeed) >= ROLL_SPEED_MIN)
			{
				isRolling = true;
				setSize(ROLLING_WIDTH_RADIUS * 2 + 1, ROLLING_HEIGHT_RADIUS * 2 + 1);
			}
			else if (Globals.spindashActive && !isSpindashing && (FlxG.keys.justPressed.Z || FlxG.keys.justPressed.X))
			{
				animation.play("spindash");
				isSpindashing = true;
				isRolling = true;
				spinrev = 0;
				spindashChargeTimer = 0;
				setSize(ROLLING_WIDTH_RADIUS * 2 + 1, ROLLING_HEIGHT_RADIUS * 2 + 1);
			}
		}
		else
		{
			crouching = false;
			if (isSpindashing)
			{
				animation.play("spindash");
				if (Globals.spindashActive)
				{
					var releaseSpeed = SPINDASH_INITIAL_SPEED + (Math.floor(spinrev) / 2);
					groundSpeed = lastFacingRight ? releaseSpeed : -releaseSpeed;
				}
				else if (spindashChargeTimer >= SPINDASH_CD_CHARGE_TIME)
				{
					groundSpeed = lastFacingRight ? SPINDASH_CD_SPEED : -SPINDASH_CD_SPEED;
				}
				isSpindashing = false;
			}
			else if (isRolling && Math.abs(groundSpeed) < ROLL_SPEED_MIN)
			{
				isRolling = false;
				setSize(STANDING_WIDTH_RADIUS * 2 + 1, STANDING_HEIGHT_RADIUS * 2 + 1);
			}
		}
		
		if (isSpindashing)
		{
			if (Globals.spindashActive)
			{
				animation.play("spindash");
				if (FlxG.keys.justPressed.Z || FlxG.keys.justPressed.X)
				{
					spinrev = Math.min(spinrev + SPINDASH_CHARGE_INCREMENT, SPINDASH_MAX_CHARGE);
				}				
				spinrev -= ((spinrev / 0.125) / 256);
			}
			else
			{
				spindashChargeTimer++;
			}
		}
		
		if (!isSpindashing)
		{
			if (isRolling )
			{
				handleRollingMovement();
			}
			else
			{
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
	
	private function handleRollingMovement():Void
	{
		if (FlxG.keys.pressed.LEFT && groundSpeed > 0)
		{
			var totalDecel = ROLL_DECELERATION_SPEED + ROLL_FRICTION_SPEED;
			groundSpeed -= totalDecel;
			
			if (groundSpeed > -totalDecel && groundSpeed < totalDecel)
			{
				groundSpeed = -0.5;
			}
		}
		else if (FlxG.keys.pressed.RIGHT && groundSpeed < 0)
		{
			var totalDecel = ROLL_DECELERATION_SPEED + ROLL_FRICTION_SPEED;
			groundSpeed += totalDecel;
			
			if (groundSpeed > -totalDecel && groundSpeed < totalDecel)
			{
				groundSpeed = 0.5;
			}
		}
		else
		{
			applyRollFriction();
		}
		
		if (Math.abs(groundSpeed) > ROLL_TOP_SPEED)
		{
			groundSpeed = ROLL_TOP_SPEED * (groundSpeed > 0 ? 1 : -1);
		}
	}
	
	private function applyRollFriction():Void
	{
		var frictionToApply = Math.min(Math.abs(groundSpeed), ROLL_FRICTION_SPEED) * (groundSpeed > 0 ? -1 : 1);
		groundSpeed += frictionToApply;
		
		if ((groundSpeed > 0 && groundSpeed + frictionToApply < 0) || 
			(groundSpeed < 0 && groundSpeed + frictionToApply > 0))
		{
			groundSpeed = 0;
		}
	}
	
	private function updateAnim():Void
	{
		if (FlxG.keys.pressed.LEFT)
		{
			lastFacingRight = false;
		}
		else if (FlxG.keys.pressed.RIGHT)
		{
			lastFacingRight = true;
		}

		if (isSpindashing)
		{
			animation.play("spindash");
			flipX = !lastFacingRight;
			return;
		}

		if (!isOnGround)
		{
			animation.play("roll");
			flipX = !lastFacingRight;
			return;
		}

		if (crouching && !isRolling && !isSpindashing)
		{
			animation.play("down");
			flipX = !lastFacingRight;
			return;
		}
		
		if (isRolling)
		{
			animation.play("roll");
			flipX = !lastFacingRight;
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