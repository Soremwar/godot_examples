extends CharacterBody2D

# The system needs an animation it can fall back to when there are none running
const DEFAULT_ANIMATION = "idle"

var scheduled_animations: Array[Dictionary] = []
var SPRITE: AnimatedSprite2D

signal test


func _ready():
	SPRITE = $Sprite
	SPRITE.animation = DEFAULT_ANIMATION
	SPRITE.animation_looped.connect(_handle_animation_sequence)

	State.update_parameters($Sprite.sprite_frames.get_animation_names())


## Animations get scheduled when their priority <= scheduled animations
## Otherwise they replace the scheduled animations
func _get_animation_priority(animation: String):
	var priority = -1
	match animation:
		"attack_1":
			priority = 1
		"attack_2":
			priority = 1
		"attack_3":
			priority = 1
		"climb":
			priority = 3
		"death":
			priority = 5
		"idle":
			priority = 0
		"hurt":
			priority = 5
		"jump_1":
			priority = 4
		"jump_2":
			priority = 4
		"run":
			priority = 1
		"run_attack":
			priority = 2
		var unsupported:
			push_error('Unsupported animation "%s"' % unsupported)

	return priority


func _handle_animation_sequence():
	if scheduled_animations.size() > 1:
		# Remove first item
		scheduled_animations = scheduled_animations.slice(1)
		SPRITE.animation = scheduled_animations.front().name
	else:
		scheduled_animations = []
		SPRITE.animation = DEFAULT_ANIMATION

	State.update_scheduled_animations(scheduled_animations)


func trigger_animation(animation: String):
	var priority = _get_animation_priority(animation)
	var new_animation = {"name": animation, "priority": priority}

	if priority != -1:
		var max_existing_priority = _get_animation_priority(DEFAULT_ANIMATION)
		for x in scheduled_animations:
			if x.priority > max_existing_priority:
				max_existing_priority = x.priority

		# If upcoming animation has higher priority than all those before, change the animation and reset the animation queue
		if priority > max_existing_priority:
			SPRITE.animation = animation
			scheduled_animations = [
				new_animation,
			]
		else:
			scheduled_animations.append(new_animation)

		State.update_scheduled_animations(scheduled_animations)
