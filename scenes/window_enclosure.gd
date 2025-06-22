extends StaticBody3D

@onready var window = $"../.."

func interact(player):
	print(interact)
	window.fix()

func get_interact_text():
	return "build plank"
