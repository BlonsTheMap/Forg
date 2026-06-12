extends CharacterBody2D

@export var jumpVelocity := -100
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

func _physics_process(delta: float) -> void:
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
