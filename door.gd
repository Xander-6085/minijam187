extends Node3D

@export var open_speed = 5.0
@export var open_distance = 90
@export var cost = 75
@export var interact_text = "Press E to open the manor (Cost: 5000)"

@export var window1 : NodePath
@export var window2 : NodePath
@export var window3 : NodePath

var disappearing = -1

func _process(delta):
	if (disappearing > 0):
		position += Vector3(0, -open_speed * delta, 0)
		disappearing -= 1
		if (disappearing == 0):
			_unlock_windows()
			queue_free()

func _unlock_windows():
	if window1 != null and get_node(window1) != null:
		get_node(window1).unlocked = true
	if window2 != null and get_node(window2) != null:
		get_node(window2).unlocked = true
	if window3 != null and get_node(window3) != null:
		get_node(window3).unlocked = true
