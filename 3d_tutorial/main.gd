extends Node

@export var mob_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	$UserInterface/Retry.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()

	var spawn_location = get_node("SpawnPath/SpawnLocation")
	spawn_location.progress_ratio = randf()

	var player_position = $Player.position
	mob.initialize(spawn_location.position, player_position)

	# Connect the instance signal to the score label listener
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())

	add_child(mob)


func _on_player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()
