extends StaticBody3D

func interact(player):
	player.light += 10

func get_interact_text():
	return "Press E to buy shotgun (Cost: 1000)"
