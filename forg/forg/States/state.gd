extends Node
class_name State

signal transition

@export var jumpVelocity := -1
@export var jumpMultiplier := -1.0
@export var gravity := -1
@export var highGravity := -1
@export var maxFallSpeed := -1

@export var walljumpVelocityY := -1
@export var walljumpVelocityX := -1

@export var acceleration := -1
@export var friction := -1
@export var maxSpeed := -1

@export var holdStrength := -1

@onready var stateMachine := get_node("..")

@onready var forg := get_node("../..")

@onready var tongue := get_node("../../tongue")
@onready var tongueSprite := get_node("/root/main/tongueSprite")

func enter():
	pass

func exit():
	pass

func _ready() -> void:
	if jumpVelocity == -1:
		jumpVelocity = forg.jumpVelocity
	if jumpMultiplier == -1:
		jumpMultiplier = forg.jumpMultiplier
	if gravity == -1:
		gravity = forg.gravity
	if highGravity == -1:
		highGravity = forg.highGravity
	if maxFallSpeed == -1:
		maxFallSpeed = forg.maxFallSpeed
	if walljumpVelocityY == -1:
		walljumpVelocityY = forg.walljumpVelocityY
	if walljumpVelocityX == -1:
		walljumpVelocityX = forg.walljumpVelocityX
	if acceleration == -1:
		acceleration = forg.acceleration
	if friction == -1:
		friction = forg.friction
	if maxSpeed == -1:
		maxSpeed = forg.maxSpeed
	if holdStrength == -1:
		holdStrength = forg.holdStrength

func run():
	var direction = Input.get_axis("Left", "Right")
	
	if direction != 0 and abs(forg.velocity.x) <= abs(maxSpeed):
		forg.velocity.x = move_toward(forg.velocity.x, maxSpeed * direction, acceleration)
	else:
		forg.velocity.x = move_toward(forg.velocity.x, 0, friction)

func jump():
	var direction = Input.get_axis("Left", "Right")
	if forg.coyote > 0 and forg.jumpBuffer:
		forg.velocity.y = jumpVelocity
		forg.velocity.x = move_toward(forg.velocity.x, maxSpeed * direction, friction)
		forg.jumpBuffer = false
		if Input.is_action_pressed("Roll"):
			transition.emit(self, "airRoll")
		else: 
			transition.emit(self, "jump")
		return

func walljump():
	if forg.jumpBuffer:
		if forg.leftCoyote > 0:
			if forg.velocity.y > 0:
				forg.velocity.y = 0
			if forg.velocity.x < 0:
				forg.velocity.x = 0
			forg.jumpBuffer = false
			forg.velocity.y += walljumpVelocityY
			forg.velocity.x += walljumpVelocityX
			if Input.is_action_pressed("Roll"):
				transition.emit(self, "airRoll")
			else: 
				transition.emit(self, "jump")
			return
		if forg.rightCoyote > 0:
			if forg.velocity.y > 0:
				forg.velocity.y = 0
			if forg.velocity.x > 0:
				forg.velocity.x = 0
			forg.jumpBuffer = false
			forg.velocity.y += walljumpVelocityY
			forg.velocity.x -= walljumpVelocityX
			transition.emit(self, "jump")
			return

func grapple():
	if Input.is_action_just_pressed("Grapple"):
		transition.emit(self, "grappling")
		return

func roll():
	if forg.rollBuffer:
		forg.rollBuffer = false
		if forg.is_on_wall():
			transition.emit(self, "wallRoll")
			return
		if forg.is_on_floor():
			transition.emit(self, "groundRoll")
			return
		if forg.is_on_ceiling():
			transition.emit(self, "ceilingRoll")
			return
		transition.emit(self, "airRoll")
		return

func physicsProcess():
	pass
