extends StaticBody3D

@onready var cross = $"../.."

func interact(player):
	if player.light >= cross.weapon_cost:
		player.light -= cross.weapon_cost
		player.active_gun.buy_gun(cross.weapon_index)

func get_interact_text():
	return str("Press E to buy ", cross.weapon_name, " (Cost: ", cross.weapon_cost, ")")
