extends CharacterBody2D

enum FacingDirection { LEFT, RIGHT }

signal hit(origin_groups: Array[StringName])

@export var facing_direction: FacingDirection = FacingDirection.RIGHT
@export var player: bool

var MAIN_NODE: Node
var SPEED = 400
var PROJECTILE: PackedScene
## Used to calculate the projectile spawn offset
var MELEE_TIMER: Timer
var WIDTH: int


func _ready():
	$Sprite.animation = "idle"

	MAIN_NODE = get_tree().root.get_child(0)
	PROJECTILE = load("res://projectile.tscn")
	# Get the size of the first frame of the animation
	WIDTH = $Sprite.sprite_frames.get_frame_texture($Sprite.animation, 0).get_width()

	MELEE_TIMER = Timer.new()
	MELEE_TIMER.one_shot = 0.5
	MELEE_TIMER.wait_time = _get_animation_duration("melee")
	add_child(MELEE_TIMER)


func _process(_delta):
	# Flip the entire element instead of the texture to flip the hitboxes inside it too
	self.transform.x = (
		-abs(self.transform.x)
		if facing_direction == FacingDirection.LEFT
		else abs(self.transform.x)
	)

	var shoot_input = "player_shoot" if player else "non_player_shoot"
	var melee_input = "player_melee" if player else "non_player_melee"

	if Input.is_action_pressed(shoot_input, true) and $ProjectileTimeout.is_stopped():
		$ProjectileTimeout.start()
		$Sprite.animation = "shoot"
		$Sprite.animation_looped.connect(func(): $Sprite.animation = "idle", CONNECT_ONE_SHOT)

		var projectile = PROJECTILE.instantiate()
		var direction_factor = 1 if facing_direction == FacingDirection.RIGHT else -1

		# Mimic the projectile "owner" physics
		projectile.position = (self.position + Vector2(WIDTH * direction_factor, 0))
		projectile.collision_layer = self.collision_layer
		projectile.collision_mask = self.collision_mask

		# Shoot the projectile only in the X axis
		projectile.shoot(self.get_groups(), Vector2(direction_factor, 0))

		MAIN_NODE.add_child(projectile)

	if Input.is_action_pressed(melee_input, true) and MELEE_TIMER.is_stopped():
		MELEE_TIMER.start()
		$Sprite.animation = "melee"
		$Sprite.animation_looped.connect(func(): $Sprite.animation = "idle", CONNECT_ONE_SHOT)

		for body in $Sprite/MeleeHitbox.get_overlapping_bodies():
			# Hitbox may collide with the hurtbox
			if body == self:
				return

			if body.is_in_group("characters"):
				body.hit.emit(self.get_groups())


func _physics_process(_delta):
	if MELEE_TIMER.is_stopped():
		if player:
			var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

			if direction != Vector2.ZERO:
				if direction.x != 0:
					facing_direction = (
						FacingDirection.RIGHT if direction.x > 0 else FacingDirection.LEFT
					)
				$Sprite.animation = "walk"
			# There is gotta be a better way to implement a queueable animation
			elif $Sprite.animation != "hurt" and $Sprite.animation != "shoot":
				$Sprite.animation = "idle"

			self.velocity = direction * SPEED
	else:
		self.velocity = Vector2.ZERO
	move_and_slide()


func _get_animation_duration(animation: String):
	var duration = 0

	var speed = abs($Sprite.get_playing_speed())
	var fps = $Sprite.sprite_frames.get_animation_speed(animation)
	for x in $Sprite.sprite_frames.get_frame_count(animation):
		duration += $Sprite.sprite_frames.get_frame_duration(animation, x) / fps * speed

	return duration


func _damage():
	$Sprite.animation = "hurt"
	$Sprite.animation_looped.connect(func(): $Sprite.animation = "idle", CONNECT_ONE_SHOT)


## This function checks the provided nodes belong to the same group
func _check_same_group(
	groups_a: Array[StringName], groups_b: Array[StringName], group_name: String
):
	if groups_a.has(group_name):
		if groups_b.has(group_name):
			return true

	return false


func _on_hit(hit_origin_groups: Array[StringName]):
	for group in ["friendly", "mobs"]:
		if _check_same_group(self.get_groups(), hit_origin_groups, group):
			return

	# Deal damage if the origin of the hit is not in the same group
	self._damage()
