extends Node

# Signal for values that are not expected to change often
signal parameters_changed
signal state_changed

var state = {"scheduled_animations": []}
var parameters = {"available_animations": []}


func update_parameters(animations: PackedStringArray):
	parameters.available_animations = animations
	parameters_changed.emit()


func update_scheduled_animations(scheduled_animations: Array[Dictionary]):
	state.scheduled_animations = scheduled_animations
	state_changed.emit()
