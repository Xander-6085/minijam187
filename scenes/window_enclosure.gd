extends StaticBody3D

@onready var window = $"../.."

func interact(player):
	window.fix()

func get_interact_text():
	return "build plank"
