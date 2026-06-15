extends State
class_name Air_Roll

@export var minSpeed := 20

func enter():
	forg.velocity *= 1

func exit():
	pass

func physicsProcess():
	forg.velocity.y = move_toward(forg.velocity.y, maxFallSpeed, gravity)
	
	grapple()
	
	if abs(forg.velocity.x) < minSpeed or Input.is_action_just_released("Roll"):
		transition.emit(self, "fall")
		return
	if forg.is_on_floor() and forg.velocity.y > 0:
		transition.emit(self, "groundRoll")
	if forg.is_on_ceiling():
		transition.emit(self, "ceilingRoll")
	if forg.is_on_wall():
		transition.emit(self, "wallRoll")
		return
