extends Node3D

func _process(delta: float) -> void:
	%Player.light -= 20 * delta;
