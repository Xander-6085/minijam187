extends Node3D

@onready var gun = $pistol
@onready var bullet_scene = load("res://scenes/bullet.tscn")
var shoot_timer = -1

func get_ammo_cost():
	return gun.get_ammo_cost()

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = gun.barrel.global_position
	bullet.transform.basis = gun.barrel.global_transform.basis
	bullet.scale *= 10
	get_parent().add_child(bullet)
	var hit_success = gun.shoot() # 0 = no hit, 1 = hit, 2 = crit
	shoot_timer = 0
	return hit_success

func _process(delta):
	if shoot_timer != -1:
		shoot_timer += delta # countdown
		if shoot_timer > gun.SHOOT_TIME: # we can shoot again
			shoot_timer = -1
			
func can_shoot():
	return shoot_timer == -1
