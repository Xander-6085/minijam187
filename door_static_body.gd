extends StaticBody3D

@onready var door = $".."

func interact(player):
	if player.light >= door.cost:
		player.light -= door.cost
		door.disappearing = door.open_distance

func get_interact_text():
	return door.interact_text
