extends Node

@export var initial_state: State
@export var mob: Area2D

var states: Dictionary = {}
var current_state: State


# Animations are rough but I intend to explore animation smoothing in another repo
func _ready():
	assert(initial_state, "No initial state defined")
	assert(mob, "No mob defined")

	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(on_state_transition)

	initial_state.Enter(mob)
	current_state = initial_state


func _process(delta: float):
	current_state.Process(delta)


func on_state_transition(state: State, new_state_name: String):
	if state != current_state:
		return

	var new_state = states[new_state_name.to_lower()]
	if new_state == null:
		return

	current_state.Exit()
	new_state.Enter(mob)
	current_state = new_state
