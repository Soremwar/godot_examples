extends CharacterBody2D

const SPEED = 500.0


func _ready():
	$Sprite.animation = "idle"


func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	direction = direction.normalized()

	if direction != Vector2.ZERO:
		$Sprite.animation = "run"
	else:
		$Sprite.animation = "idle"

	# Do this to avoid flipping the sprite on 0 values
	if direction.x > 0:
		$Sprite.flip_h = false
	elif direction.x < 0:
		$Sprite.flip_h = true

	velocity = direction * SPEED

	move_and_slide()
