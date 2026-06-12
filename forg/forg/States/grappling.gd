extends State
class_name Grappling

@export var distance := 128

func enter():
	pass

func exit():
	pass

func physicsProcess():
	forg.grappleDir = Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Up", "Down")).normalized()
	if not forg.grappleDir:
		forg.grappleDir = Vector2(1,0)
	
	tongue.target_position = forg.grappleDir * distance
	tongue.force_raycast_update()
	if tongue.is_colliding():
		print("touched")
		tongueSprite.visible = true
		tongueSprite.position = tongue.get_collision_point()
		transition.emit(self, "grapplePull")
		return
	tongueSprite.visible = false
	transition.emit(self, "fall")
