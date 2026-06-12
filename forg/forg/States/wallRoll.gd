extends State
class_name Wall_Roll

@export var minSpeed := 20
@export var boost := 50
var floorNormal : Vector2

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
		forg.velocity.x = holdStrength
	if forg.touchingLeft:
		forg.velocity.x = -holdStrength
	walljump()
	grapple()
	
	if abs(forg.velocity.y) < minSpeed or Input.is_action_just_released("Roll"):
		transition.emit(self, "fall")
		return
	if forg.is_on_floor() and forg.velocity.y > 0:
		forg.velocity.x = 0
		transition.emit(self, "groundRoll")
	if forg.is_on_ceiling() and forg.velocity.y < 0:
		forg.velocity.x = 0
		transition.emit(self, "ceilingRoll")
	if not forg.is_on_wall():
		transition.emit(self, "airRoll")
		return
