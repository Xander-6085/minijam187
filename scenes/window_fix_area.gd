extends Area3D

@onready var window = $".."

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(other):
	if other is Angel:
		other.is_in_window_area(window)
