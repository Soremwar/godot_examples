extends State
class_name Attack


func Enter(p: Area2D):
	super(p)
	player.get_node("Sprite").animation = "attack"


func Process(_delta: float):
	if player.has_overlapping_bodies():
		self.transition.emit(self, "defend")
	elif not player.get_node("RayCast").is_colliding():
		self.transition.emit(self, "idle")


func Exit():
	pass
