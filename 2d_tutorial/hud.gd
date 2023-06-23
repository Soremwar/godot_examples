extends CanvasLayer

signal start_game


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func set_score(score: String):
	$ScoreLabel.text = score


func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()


func show_game_over():
	show_message("Game over")

	await $MessageTimer.timeout

	$MessageLabel.text = "Dodge the Creeps!"
	$MessageLabel.show()

	# Await custom timer before spawning start button
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()


func update_score(score):
	$ScoreLabel.text = str(score)


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout():
	$MessageLabel.hide()
