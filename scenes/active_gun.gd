extends Node3D

@onready var gun = $pistol
var shoot_timer = -1

func get_ammo_cost():
	return gun.get_ammo_cost()

func shoot():
	var hit_success = gun.shoot() # 0 = no hit, 1 = hit, 2 = crit
	shoot_timer = 0
	return hit_success
	
func claim_bounty():
	var bounty = gun.bounty
	gun.bounty = 0
	return bounty;

func _process(delta):
	if shoot_timer != -1:
		shoot_timer += delta # countdown
		if shoot_timer > gun.shoot_time: # we can shoot again
			shoot_timer = -1
			
func can_shoot(light):
	return shoot_timer == -1 && light >= get_ammo_cost()
