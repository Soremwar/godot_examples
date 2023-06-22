extends State
class_name Defend


func Enter(p: Area2D):
	super(p)
	player.get_node("Sprite").animation = "defend"


func Process(_delta: float):
	if not player.has_overlapping_bodies():
		if player.get_node("RayCast").is_colliding():
			self.transition.emit(self, "attack")
		else:
			self.transition.emit(self, "idle")


func Exit():
	pass
