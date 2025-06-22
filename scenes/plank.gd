extends StaticBody3D

@onready var window = $"../.."
@onready var plank = $".."

func interact():
	print(interact)
	window.damage()

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
