extends State
class_name Ceiling_Roll

@export var minimumSpeed := 20
var minSpeed := 0
@export var boost := 50
var floorNormal : Vector2

func enter():
	minSpeed = minimumSpeed
	forg.velocity.y = -holdStrength
	var direction : int
	if forg.touchingLeft:
		direction = 1
	if forg.touchingRight:
		direction = -1
	
	forg.velocity.x += abs(forg.velocity.y) * direction

func exit():
	pass

func physicsProcess():
	forg.velocity.x = move_toward(forg.velocity.x, 0, friction)
	forg.velocity.y = -holdStrength
	grapple()
	#minSpeed += 2
	
	if abs(forg.velocity.x) < minSpeed or Input.is_action_just_released("Roll"):
		transition.emit(self, "fall")
		return
	if (forg.touchingRight and forg.velocity.x > 0) or (forg.touchingLeft and forg.velocity.x < 0):
		forg.velocity.y = 1
		transition.emit(self, "wallRoll")
		return
	if not forg.is_on_ceiling():
		transition.emit(self, "airRoll")
		forg.velocity.y = -abs(forg.velocity.x)
		tongue.position = Vector2(0,-4)
		if forg.velocity.x > 0:
			forg.velocity.x = -1
			tongue.target_position = Vector2(-16,0)
			tongue.force_raycast_update()
			if tongue.is_colliding():
				forg.position = Vector2(tongue.get_collision_point().x + 4, tongue.get_collision_point().y)
		else:
			forg.velocity.x = 1
			tongue.target_position = Vector2(16,0)
			tongue.force_raycast_update()
			if tongue.is_colliding():
				forg.position = Vector2(tongue.get_collision_point().x - 4, tongue.get_collision_point().y)
		return
