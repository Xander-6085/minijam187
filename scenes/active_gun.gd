extends Node3D

@onready var pistol = $pistol

@onready var guns = [$pistol, $staff]
var guns_bought = [true, false]

@onready var gun = guns[0]

var shoot_timer = -1

#func _ready():
#	$pistol.queue_free()
#	gun = $staff

func buy_gun(index):
	guns_bought[index] = true
	swap_to_gun(index)

func swap_to_gun(index):
	gun.visible = false
	gun = guns[index]
	gun.visible = true

func get_ammo_cost():
	return gun.get_ammo_cost()

func shoot():
	var hit_success = gun.shoot($LineOfSightCast) # 0 = no hit, 1 = hit, 2 = crit
	shoot_timer = 0
	return hit_success
	
func stop_shooting():
	if gun.has_method("stop_shooting"):
		gun.stop_shooting() # 0 = no hit, 1 = hit, 2 = crit
	
func claim_bounty():
	var bounty = gun.bounty
	gun.bounty = 0
	print("bounty: ", bounty)
	return bounty;

func _process(delta):
	if shoot_timer != -1:
		shoot_timer += delta # countdown
		if shoot_timer > gun.shoot_time: # we can shoot again
			shoot_timer = -1
			
func can_shoot(light):
	return shoot_timer == -1 && light >= get_ammo_cost()
