extends StaticBody3D

@export var open_distance = 90
@export var cost = 75

@onready var door = $".."

func interact(player):
	if player.light >= cost:
		player.light -= cost
		door.disappearing = open_distance

func get_interact_text():
	return "Press E to open the manor (Cost: 5000)"
