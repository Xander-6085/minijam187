extends MeshInstance3D
class_name Cross

@export var speed = 5.0

func _process(delta):
	rotate_y(speed*delta)
