extends Node3D

@export var open_speed = 5.0
@export var open_distance = 90
@export var cost = 75
@export var interact_text = "Press E to open the manor (Cost: 5000)"
var disappearing = -1

func _process(delta):
	if (disappearing > 0):
		position += Vector3(0, -open_speed * delta, 0)
		disappearing -= 1
		if (disappearing == 0):
			queue_free()
