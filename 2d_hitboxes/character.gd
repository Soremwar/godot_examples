extends CharacterBody2D

enum FacingDirection { LEFT, RIGHT }

signal hit(origin_groups: Array[StringName])

@export var player: bool

var MAIN_NODE: Node
var SPEED = 400
var PROJECTILE: PackedScene
## Used to calculate the projectile spawn offset
var WIDTH: int

var facing_direction = FacingDirection.LEFT


func _ready():
	$Sprite.animation = "idle"

	MAIN_NODE = get_tree().root.get_child(0)
	PROJECTILE = load("res://projectile.tscn")
	# Get the size of the first frame of the animation
	WIDTH = $Sprite.sprite_frames.get_frame_texture($Sprite.animation, 0).get_width()


func _process(_delta):
	if player:
		$Sprite.flip_h = facing_direction == FacingDirection.LEFT

		if Input.is_action_pressed("action_shoot") and $ProjectileTimeout.is_stopped():
			$ProjectileTimeout.start()
			$Sprite.animation = "shoot"
			$Sprite.animation_looped.connect(func(): $Sprite.animation = "idle", CONNECT_ONE_SHOT)

			var projectile = PROJECTILE.instantiate()
			var direction_multiplier = 1 if facing_direction == FacingDirection.RIGHT else -1

			# Mimic the projectile "owner" physics
			projectile.position = (self.position + Vector2(WIDTH * direction_multiplier, 0))
			projectile.collision_layer = self.collision_layer
			projectile.collision_mask = self.collision_mask

			# Shoot the projectile only in the X axis
			projectile.shoot(self.get_groups(), Vector2(direction_multiplier, 0))

			MAIN_NODE.add_child(projectile)


func _physics_process(_delta):
	if player:
		var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

		if direction != Vector2.ZERO:
			if direction.x != 0:
				facing_direction = (
					FacingDirection.RIGHT if direction.x > 0 else FacingDirection.LEFT
				)
			$Sprite.animation = "walk"
		# There is gotta be a better way to implement a queueable animation
		elif $Sprite.animation != "shoot":
			$Sprite.animation = "idle"

		self.velocity = direction * SPEED
	move_and_slide()


func _damage():
	$Sprite.animation = "hurt"
	$Sprite.animation_looped.connect(func(): $Sprite.animation = "idle", CONNECT_ONE_SHOT)


func _on_hit(origin_groups: Array[StringName]):
	if self.get_groups().has("mobs"):
		if origin_groups.has("friendly"):
			self._damage()

	if self.get_groups().has("friendly"):
		if origin_groups.has("mobs"):
			self._damage()
