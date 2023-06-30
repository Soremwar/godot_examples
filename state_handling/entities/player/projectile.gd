extends Area2D

const SPEED = 300

var horizontal_direction = 0


func _ready():
	pass


func _process(_delta):
	var destroy = false

	for area in self.get_overlapping_areas():
		if area is LightMob:
			area.hit.emit()
			destroy = true

	if destroy:
		queue_free()


func _physics_process(delta):
	if horizontal_direction != 0:
		self.position.x += horizontal_direction * SPEED * delta


func shoot(direction: int):
	if horizontal_direction == 0 && direction != 0:
		if direction > 0:
			horizontal_direction = 1
		else:
			horizontal_direction = -1
