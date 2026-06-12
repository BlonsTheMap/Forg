extends State
class_name Grapple_Pull

@export var pullSpeed := 200
@export var grappleTime := 10
var grappleTimer := 0

@export var distance := 24

func enter():
	forg.position.y -= 1
	tongue.target_position = forg.grappleDir * distance
	forg.velocity = forg.grappleDir * pullSpeed
	grappleTimer = grappleTime

func exit():
	forg.justPulled = true
	forg.fallSpeed = 0
	var direction = Input.get_axis("Left", "Right")
	
	forg.velocity = forg.velocity.limit_length(pullSpeed)
	
	tongueSprite.visible = false
	if Input.is_action_pressed("Roll"):
		if forg.is_on_wall():
			forg.velocity.y = -pullSpeed * .9
			if forg.grappleDir.y > 0:
				forg.velocity.y = pullSpeed
			if forg.grappleDir.y < 0:
				forg.velocity.y = -pullSpeed
			return
		if forg.is_on_floor() or forg.is_on_ceiling():
			forg.velocity.x = pullSpeed * direction
			if forg.grappleDir.x > 0:
				forg.velocity.x = pullSpeed
			if forg.grappleDir.x < 0:
				forg.velocity.x = -pullSpeed
			return
		forg.velocity = forg.grappleDir * pullSpeed

func physicsProcess():
	if forg.grappleDir.y != 0 and (is_zero_approx(forg.velocity.y) ):
		grappleTimer -= 1
	else: if forg.grappleDir.x != 0 and is_zero_approx(forg.velocity.x):
		grappleTimer -= 1
	
	if grappleTimer == grappleTime:
		forg.velocity = forg.grappleDir * pullSpeed * 1.5
	else:
		forg.velocity = Vector2(0,0)
	
	if grappleTimer <= 0:
		transition.emit(self, "fall")
	
	if Input.is_action_just_pressed("Grapple"):
		transition.emit(self, "fall")
	
	forg.coyote = 1
	
	tongue.force_raycast_update()
	if forg.get_slide_collision_count():
		bounce()
		roll()
	if not tongue.is_colliding():
		roll()
		jump()
