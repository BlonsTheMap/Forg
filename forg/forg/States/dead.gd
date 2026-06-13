extends State
class_name Dead

func enter():
	pass

func exit():
	pass

func physicsProcess():
	forg.velocity.y += gravity
	if forg.position.y >= 100:
		get_tree().reload_current_scene()
