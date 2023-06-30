extends Node

signal state_changed

var state = {"score": 0}


func increase_score():
	state.score += 1
	state_changed.emit()
