extends CharacterBody2D

const SPEED = 500.0

var MAIN_NODE: Node
var PROJECTILE_SCENE: PackedScene
var PROJECTILE_TIMER: Timer


func _ready():
	MAIN_NODE = get_node("/root/Main")
	PROJECTILE_SCENE = load("res://entities/player/projectile.tscn")
	PROJECTILE_TIMER = $ProjectileTimer

	$Sprite.animation = "idle"


func _process(_delta):
	if Input.is_action_just_pressed("player_shoot") && PROJECTILE_TIMER.is_stopped():
		var projectile = PROJECTILE_SCENE.instantiate()
		projectile.position = self.position
		projectile.collision_layer = self.collision_layer
		projectile.collision_mask = self.collision_mask
		MAIN_NODE.add_child(projectile)

		# This is terrible but I don't need a directional system
		projectile.shoot(-1 if $Sprite.flip_h else 1)

		PROJECTILE_TIMER.start()


func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	direction = direction.normalized()

	if direction != Vector2.ZERO:
		$Sprite.animation = "run"
	else:
		$Sprite.animation = "idle"

	# Do this to avoid flipping the sprite on 0 values
	if direction.x > 0:
		$Sprite.flip_h = false
	elif direction.x < 0:
		$Sprite.flip_h = true

	velocity = direction * SPEED

	move_and_slide()
