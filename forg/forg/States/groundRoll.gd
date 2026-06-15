extends State
class_name Ground_Roll

@export var minSpeed := 20
@export var boost := 50
var floorNormal : Vector2

func enter():
	var direction : int
	if forg.touchingLeft:
		direction = 1
	if forg.touchingRight:
		direction = -1
	
	forg.velocity.x += abs(forg.fallSpeed) * direction

func exit():
	pass

func physicsProcess():
	forg.coyote = forg.coyoteTime
	forg.velocity.x = move_toward(forg.velocity.x, 0, friction)
	forg.velocity.y = holdStrength
	jump()
	grapple()
	
	if abs(forg.velocity.x) < minSpeed or Input.is_action_just_released("Roll"):
		transition.emit(self, "grounded")
		return
	if (forg.touchingRight and forg.velocity.x > 0) or (forg.touchingLeft and forg.velocity.x < 0):
		forg.velocity.y = 0
		transition.emit(self, "wallRoll")
		return
	if not forg.is_on_floor():
		transition.emit(self, "airRoll")
		forg.velocity.y = abs(forg.velocity.x)
		forg.velocity.x *= -0.25
		return
