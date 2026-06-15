extends State
class_name Bounce

@export var bounceTime := 10
var bounceTimer := 0

func enter():
	bounceTimer = bounceTime

func exit():
	pass

func physicsProcess():
	bounce()
	bounceTimer -= 1
	if bounceTimer == 0:
		transition.emit(self, "fall")
	if forg.get_slide_collision_count():
		roll()
