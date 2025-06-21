extends StaticBody3D

@export var open_distance = 90

@onready var door = $".."

func interact():
	door.disappearing = open_distance

func get_interact_text():
	return "Press E to open the manor (Cost: 5000)"
