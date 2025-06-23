extends StaticBody3D

@onready var door = $".."

func interact(player):
	if player.active_gun.has_all_guns():
		door.disappearing = door.open_distance

func get_interact_text():
	return door.interact_text
