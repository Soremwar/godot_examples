extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	assert(mob_types.size() > 0, "No sprites defined")

	# Pick a random animation from the available sprite sets
	var enemy_type = mob_types[randi_range(0, mob_types.size() - 1)]

	$AnimatedSprite2D.play(enemy_type)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
