extends Node2D

@export var mob_number = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(mob_number < 10, "The scene can't handle more than 10 mobs without overlapping")
	var mob_scenes = [
		load("res://entities/mobs/drone.tscn"),
	]

	for _x in mob_number:
		var mob_scene = mob_scenes[randi() % mob_scenes.size()]
		var mob = mob_scene.instantiate()
		var location = _get_random_location()

		mob.position = location.position
		add_child(mob)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Get a random position from the defined path
func _get_random_location():
	var spawn_location = $Path/SpawnLocation
	spawn_location.progress_ratio = randf()
	return spawn_location
