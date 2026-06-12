extends State
class_name Grounded

func enter():
	pass

func exit():
	pass

func physicsProcess():
	forg.coyote = forg.coyoteTime
	run()
	jump()
	grapple()
	roll()
	
	if not forg.is_on_floor():
		transition.emit(self, "fall")
		return
