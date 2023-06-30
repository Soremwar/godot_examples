extends Control


func _ready():
	_update()
	GlobalState.state_changed.connect(_update)


func _update():
	_set_score(GlobalState.state.score)


func _set_score(score: int):
	$Score.text = "Score: %d" % score
