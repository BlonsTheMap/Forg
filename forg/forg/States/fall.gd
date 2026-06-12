extends State
class_name Fall

func enter():
	pass

func exit():
	pass

func physicsProcess():
	forg.velocity.y = move_toward(forg.velocity.y, maxFallSpeed, gravity)
	run()
	jump()
	walljump()
	grapple()
	roll()
	
	if forg.is_on_floor():
		transition.emit(self, "grounded")
		return
