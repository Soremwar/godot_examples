extends Node2D

var MIN_MOB_SPEED = 150.0
var MAX_MOB_SPEED = 250.0

@export var mob_scene: PackedScene

var score: int


func update_UI():
	$UI.set_score(score)


func start_game():
	score = 0
	$Player.start($PlayerInitialPosition.position)
	update_UI()

	$MobTimer.start()
	$ScoreTimer.start()


func game_over():
	$MobTimer.stop()
	$ScoreTimer.stop()


# Called when the node enters the scene tree for the first time.
func _ready():
	start_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_UI()


func _on_player_hit():
	game_over()


func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()

	var spawn_location = $MobPath/SpawnLocation
	spawn_location.progress_ratio = randf()

	var direction = spawn_location.rotation + PI / 2

	mob.position = spawn_location.position

	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	var velocity = Vector2(randf_range(MIN_MOB_SPEED, MAX_MOB_SPEED), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	add_child(mob)


func _on_score_timer_timeout():
	score += 1
