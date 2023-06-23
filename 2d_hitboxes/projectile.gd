extends Area2D

var SPEED = 500

var direction = Vector2.ZERO
var groups: Array[StringName]


func _physics_process(delta):
	if direction != Vector2.ZERO:
		position.x += direction.x * SPEED * delta


# one-shot function that fires the projectile in the specified direction
func shoot(parent_groups: Array[StringName], projectile_direction: Vector2):
	if direction == Vector2.ZERO:
		groups = parent_groups
		direction = projectile_direction


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body: Node2D):
	if body == null:
		return

	if body.is_in_group("characters"):
		body.hit.emit(groups)

	queue_free()
