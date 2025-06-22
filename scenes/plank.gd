extends StaticBody3D
class_name Plank

@onready var window = $"../.."
@onready var plank = $".."

func interact(player):
	window.damage(1)
	
func damage(amount):
	window.damage(amount)

func get_interact_text():
	return "destroy plank"
	
func show_all():
	plank.show()
	$CollisionShape3D.disabled = false
	$CollisionShape3D.show()
	
func hide_all():
	$CollisionShape3D.hide()
	$CollisionShape3D.disabled = true
	plank.hide()
