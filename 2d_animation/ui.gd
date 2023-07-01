extends Control


func _ready():
	_update_parameters()
	_update()

	State.state_changed.connect(_update)
	State.parameters_changed.connect(_update_parameters)


func _update_parameters():
	_set_available_animations(State.parameters.available_animations)


func _set_available_animations(animations: PackedStringArray):
	for animation in animations:
		var button = Button.new()
		button.text = animation
		button.pressed.connect(
			func(): get_node("/root/Main/ScheduleCharacter").trigger_animation(animation)
		)
		$AnimationControl.add_child(button)


func _update():
	_set_active_animation(State.state.scheduled_animations)
	_set_scheduled_animations(State.state.scheduled_animations)


func _set_active_animation(animations: Array):
	if animations.size() > 0:
		$ActiveAnimation.text = animations.front().name
	else:
		$ActiveAnimation.text = ""


func _set_scheduled_animations(animations: Array):
	$ScheduledAnimations.text = "\n".join(PackedStringArray(animations.map(func(x): return x.name)))
