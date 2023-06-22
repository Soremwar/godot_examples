extends Node
class_name State

# A signal to signify the switch from this state
signal transition

var player: Area2D


# Called once when the state is set to active
func Enter(p: Area2D):
	player = p


# Called every frame the state is active
func Process(_delta: float):
	pass


# Called once when the state is set to inactive
func Exit():
	pass
