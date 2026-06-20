extends State
class_name Wall_Roll

@export var minSpeed := 20
@export var boost := 50
var floorNormal : Vector2
var wallDirection := 0

func enter():
	if not forg.justPulled:
		if forg.velocity.y > 0:
			forg.velocity.y += abs(forg.velocity.x)
		else:
			forg.velocity.y -= abs(forg.velocity.x)

func exit():
	pass

func physicsProcess():
	forg.velocity.y += gravity
	
	if forg.touchingRight:
		wallDirection = 1
	if forg.touchingLeft:
		wallDirection = -1
	forg.velocity.x = holdStrength * wallDirection
	walljump()
	grapple()
	
	if Input.is_action_just_released("Roll") or abs(forg.velocity.y) < minSpeed:
		transition.emit(self, "fall")
		return
	if forg.is_on_floor() and forg.velocity.y > 0:
		forg.velocity.x = 0
		transition.emit(self, "groundRoll")
	if forg.is_on_ceiling():
		forg.velocity.x = 0
		transition.emit(self, "ceilingRoll")
	if not forg.is_on_wall():
		transition.emit(self, "airRoll")
		forg.velocity.x = abs(forg.velocity.y) * wallDirection
		tongue.position = Vector2(4*wallDirection, 0)
		if forg.velocity.y >= 0:
			forg.velocity.y = -1
			tongue.target_position = Vector2(0,-16)
			tongue.force_raycast_update()
			if tongue.is_colliding():
				forg.position.y = tongue.get_collision_point().y + 4
		else:
			forg.velocity.y = 1
			tongue.target_position = Vector2(0,16)
			tongue.force_raycast_update()
			if tongue.is_colliding():
				forg.position.y = tongue.get_collision_point().y - 4
		return
