extends CharacterBody3D

@export var bounce_impulse = 16
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var speed = 14

signal hit

var target_velocity = Vector3.ZERO


func _physics_process(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_up"):
		direction.z -= 1
	if Input.is_action_pressed("move_down"):
		direction.z += 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(position + direction, Vector3.UP)
		$AnimationPlayer.speed_scale = 4
	else:
		$AnimationPlayer.speed_scale = 1

	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	if is_on_floor() and Input.is_action_pressed("jump"):
		target_velocity.y += jump_impulse

	# Gravity
	if not is_on_floor():
		target_velocity.y -= (fall_acceleration * delta)

	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)

		if collision.get_collider() == null:
			continue

		if collision.get_collider().is_in_group("mobs"):
			var mob = collision.get_collider()
			# we check that we are hitting it from above.
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				mob.squash()
				target_velocity.y = bounce_impulse

	velocity = target_velocity

	$Pivot.rotation.x = PI / 6 * velocity.y / jump_impulse

	move_and_slide()


func die():
	hit.emit()
	queue_free()


func _on_mob_detector_body_entered(_body: Node3D):
	die()
