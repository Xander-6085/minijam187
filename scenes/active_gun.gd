extends Node3D

@onready var pistol = $pistol

@onready var guns = [$pistol, $staff, $Shotgun]
var guns_bought = [true, false, false]

@onready var gun = guns[0]
var gun_index = 0

var shoot_timer = -1
var swap_timer = -1
@export var swap_time = 0.3

#func _ready():
#	$pistol.queue_free()
#	gun = $staff

func buy_gun(index):
	print("Buying: ", index)
	guns_bought[index] = true
	swap_to_gun(index)

func swap_to_gun(index):
	if swap_timer == -1:
		if index < 0:
			index = len(guns) - 1
		elif index >= len(guns):
			index = 0
		if guns_bought[index]:
			gun.visible = false
			gun = guns[index]
			gun_index = index
			gun.visible = true
			swap_timer = 0

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
	if swap_timer != -1:
		swap_timer += delta # countdown
		if swap_timer > swap_time: # we can shoot again
			swap_timer = -1
	
	if Input.is_action_pressed("1"):
		swap_to_gun(0)
	elif Input.is_action_pressed("2"):
		swap_to_gun(1)
			
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			var index = gun_index + 1
			swap_to_gun(index)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var index = gun_index - 1
			swap_to_gun(index)
			
	
func can_shoot(light):
	return shoot_timer == -1 && light >= get_ammo_cost()

func has_all_guns():
	return guns_bought[1] and guns_bought[2]
