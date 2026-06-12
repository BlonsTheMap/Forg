extends Node

@export var initialState : State
var currentState : State
var lastState : State
var states : Dictionary = {}

@onready var forg = get_node("..")

func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(onTransition)
	
	if initialState:
		initialState.enter()
		currentState = initialState

func onTransition(state, newStateName):
	print(state, " to ", newStateName)
	if state != currentState:
		print("leaving wrong state")
		return
	
	var newState = states.get(newStateName)
	if !newState:
		print("invalid state")
		return
	
	if currentState:
		currentState.exit()
	
	newState.enter()
	lastState = currentState
	currentState = newState
	forg.justPulled = false
