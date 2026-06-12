extends State
class_name Jump

func enter():
	pass

func exit():
	pass

func physicsProcess():
	if Input.is_action_pressed("Jump"):
		forg.velocity.y += gravity
	else:
		forg.velocity.y += highGravity
	run()
	walljump()
	grapple()
	roll()
	
	if forg.is_on_floor():
		transition.emit(self, "grounded")
		return
	if forg.velocity.y > 0:
		transition.emit(self, "fall")
		return
