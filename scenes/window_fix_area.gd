extends Area3D

var player = null
@onready var window = $".."

func _on_body_entered(other):
	if other is Angel:
		player.is_in_window_area(window)
