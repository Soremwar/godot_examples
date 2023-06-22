extends Node2D

var MIN_MOB_SPEED = 150.0
var MAX_MOB_SPEED = 250.0
var TITLE = "Dodge the creeps!"

@export var mob_scene: PackedScene

var score: int


func update_HUD():
	$UI.set_score(score)


func start_game():
	score = 0

	get_tree().call_group("mobs", "queue_free")
	$UI/Message.text = "Get ready!"
	$UI/StartButton.hide()
	$Player.start($PlayerInitialPosition.position)
	$Music.play()

	# Reflect score reset
	update_HUD()

	await get_tree().create_timer(2.0).timeout

	$UI/Message.hide()
	$MobTimer.start()
	$ScoreTimer.start()


func game_over():
	$Music.stop()
	$DeathSound.play()

	$MobTimer.stop()
	$ScoreTimer.stop()

	$UI/Message.text = "Game over"
	$UI/Message.show()

	await get_tree().create_timer(2.0).timeout

	$DeathSound.stop()	
	$Player.start($PlayerInitialPosition.position)
	$Player.show()
	$UI/Message.text = TITLE
	$UI/StartButton.show()


func _ready():
	$Player.start($PlayerInitialPosition.position)
	$UI/Message.text = TITLE


func _process(_delta):
	update_HUD()


func _on_player_hit():
	# Hide it, don't kill it
	$Player.hide()
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


func _on_button_pressed():
	start_game()
