extends "res://scripts/demon.gd"

func _process(delta: float):
	if $body_collider.disabled:
		$body_collider2.disabled = true
		
		
