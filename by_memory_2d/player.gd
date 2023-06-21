extends Area2D

var speed = 400

signal hit


func _process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		self.position.x += direction.x * speed * delta
		self.position.y += direction.y * speed * delta

		if direction.x != 0:
			$Animation.animation = "walk"
			$Animation.flip_h = direction.x < 0
			$Animation.flip_v = false
		elif direction.y != 0:
			$Animation.animation = "up"
			$Animation.flip_h = false
			$Animation.flip_v = direction.y > 0
		$Animation.speed_scale = 1.0
		$Animation.play()
	else:
		$Animation.animation = "walk"
		$Animation.speed_scale = 0.5
		$Animation.play()


func start(starting_position: Vector2):
	self.position = starting_position


func _on_body_entered(body: Node2D):
	if body.is_in_group("mobs"):
		hit.emit()
		queue_free()
