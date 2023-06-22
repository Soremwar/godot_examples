extends State
class_name Idle


func Enter(p: Area2D):
	super(p)
	player.get_node("Sprite").animation = "idle"


func Process(_delta: float):
	if player.has_overlapping_bodies():
		self.transition.emit(self, "defend")
	elif player.get_node("RayCast").is_colliding():
		self.transition.emit(self, "attack")


func Exit():
	pass
