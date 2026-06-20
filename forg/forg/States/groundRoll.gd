extends State
class_name Ground_Roll

var floorNormal : Vector2

func enter():
	maxSpeed = abs(forg.velocity.x)/2 + 100
	var direction : int
	if forg.touchingLeft:
		direction = 1
	if forg.touchingRight:
		direction = -1
	
	forg.velocity.x += abs(forg.velocity.y) * direction

func exit():
	pass

func physicsProcess():
	forg.coyote = forg.coyoteTime
	forg.velocity.y = holdStrength
	jump()
	grapple()
	run()
	maxSpeed -= 2
	
	if Input.is_action_just_released("Roll") or maxSpeed < 10:
		transition.emit(self, "grounded")
		return
	if (forg.touchingRight and forg.velocity.x > 0) or (forg.touchingLeft and forg.velocity.x < 0):
		forg.velocity.y = 0
		transition.emit(self, "wallRoll")
		return
	if not forg.is_on_floor():
		transition.emit(self, "airRoll")
		forg.velocity.y = abs(forg.velocity.x)
		tongue.position = Vector2(0,4)
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
