extends State
class_name Ceiling_Roll

@export var minimumSpeed := 20
var minSpeed := 0
@export var boost := 50
var floorNormal : Vector2

func enter():
	minSpeed = minimumSpeed
	forg.velocity.y = -holdStrength

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
		forg.velocity.x *= -0.5
		return
