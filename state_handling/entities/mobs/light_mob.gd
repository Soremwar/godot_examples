extends Area2D
class_name LightMob

signal hit

# The max amount of pixels a character can move from their initial position
const LIMITER = 500
# In seconds
const MAX_MOVEMENT_FREQUENCY = 10
const MOVEMENT = 200
const SPEED = 100

var scheduled_movement = 0.0
var boundaries = {"low": null, "high": null}
# Timer has to be one shot to be able to check for stopped status instead of relying on the signal
var timer: Timer


func _ready():
	boundaries.low = self.position.x - LIMITER
	boundaries.high = self.position.x + LIMITER
	timer = $MoveTimer

	hit.connect(_on_hit)


func _process(_delta):
	if timer.is_stopped() && scheduled_movement == 0:
		scheduled_movement = randf_range(-MOVEMENT, MOVEMENT)
		timer.start(randi_range(1, MAX_MOVEMENT_FREQUENCY))


func _physics_process(delta):
	if scheduled_movement != 0:
		var original_scheduled_movement = scheduled_movement
		var frame_movement = 0.0

		if scheduled_movement > 0:
			frame_movement = SPEED * delta
		else:
			frame_movement = -SPEED * delta

		scheduled_movement -= frame_movement

		# Every frame check if the movement has gone past 0, meaning there is no more movement to do
		if (
			(original_scheduled_movement > 0 && scheduled_movement < 0)
			|| (original_scheduled_movement < 0 && scheduled_movement > 0)
		):
			scheduled_movement = 0

		var target_movement = self.position.x + frame_movement
		self.position.x = clamp(target_movement, boundaries.low, boundaries.high)


func _on_hit():
	GlobalState.increase_score()
