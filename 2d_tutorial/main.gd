extends Node

@export var mob_scene: PackedScene
@export var MIN_SPEED: float = 150.0
@export var MAX_SPEED: float = 250.0

var score = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD.update_score(score)
	$HUD.show_message("Get ready")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()


func new_game():
	# Cleanup
	get_tree().call_group("mobs", "queue_free")

	# Initialize
	score = 0
	# The timer won't refresh periodically at this point
	$HUD.set_score(str(score))
	$Music.play()

	# Start
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()

	var spawn_location = get_node("MobPath/MobSpawnLocation")
	spawn_location.progress_ratio = randf()

	var direction = spawn_location.rotation + (PI / 2)

	print(spawn_location.position)
	mob.position = spawn_location.position

	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(randf_range(MIN_SPEED, MAX_SPEED), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
