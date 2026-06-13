extends CharacterBody2D

@export var jumpVelocity := -100
@export var bounceVelocity := 200
@export var jumpMultiplier := 1.0
@export var gravity := 20
@export var highGravity := 40
@export var maxFallSpeed := 100

@export var walljumpVelocityY := -100
@export var walljumpVelocityX := 50

@export var acceleration := 10
@export var friction := 10
@export var maxSpeed := 100

@export var holdStrength := 20

@export var coyoteTime := 6

var coyote := 0
var leftCoyote := 0
var rightCoyote := 0
var jumpBuffer := false

var touchingRight := 0
var touchingLeft := 0

@onready var states := $stateMachine

var grappleDir : Vector2
var justPulled := false

var rollBuffer := false
var fallSpeed := 0

var dead := false

func die(dieVector):
	if not dead:
		dead = true
		set_collision_layer_value(1, false)
		set_collision_mask_value(2, false)
		if dieVector.x != 0:
			velocity.x = dieVector.x
		if dieVector.y != 0:
			velocity.y = dieVector.y
		states.currentState = states.states.get("dead")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Retry"):
		die(Vector2(0, 200))
	
	if Input.is_action_just_pressed("Jump"):
		jumpBuffer = true
	if Input.is_action_just_released("Jump"):
		jumpBuffer = false
	
	if Input.is_action_just_pressed("Roll"):
		rollBuffer = true
	if Input.is_action_just_released("Roll"):
		rollBuffer = false
	
	if touchingLeft:
		leftCoyote = coyoteTime
	if touchingRight:
		rightCoyote = coyoteTime
	
	states.currentState.physicsProcess()
	
	fallSpeed = velocity.y
	move_and_slide()
	coyote -= 1
	leftCoyote -= 1
	rightCoyote -= 1

func _on_left_area_body_entered(body: Node2D) -> void:
	touchingLeft += 1
func _on_left_area_body_exited(body: Node2D) -> void:
	touchingLeft -= 1

func _on_right_area_body_entered(body: Node2D) -> void:
	touchingRight += 1
func _on_right_area_body_exited(body: Node2D) -> void:
	touchingRight -= 1

func _on_hitbox_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	var tile : Vector2i = body.get_coords_for_body_rid(body_rid)
	var data : TileData = body.get_cell_tile_data(tile)
	var outVector = data.get_custom_data("Out Vector")
	if outVector.dot(velocity.normalized()) <= 0:
		die(outVector * 200)
