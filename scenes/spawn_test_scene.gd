extends Node3D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		var foo = $LevelBase;
		foo.run_wave(0)
