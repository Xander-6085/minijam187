extends StaticBody3D

@onready var window = $"../.."

func interact():
	print(interact)
	window.fix()

func get_interact_text():
	return "build plank"
