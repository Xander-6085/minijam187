extends Node3D

@export var shoot_time = 0.3
@export var damage = 5
@export var ammo_cost = 5

@onready var raycast = $RayCast3D
@onready var bullet_scene = load("res://scenes/bullet.tscn")

var bounty = 0

func shoot():
	$AnimationPlayer.play("shoot")
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet);
	
	bullet.global_transform = raycast.global_transform
	bullet.scale = Vector3.ONE;
	
	raycast.force_raycast_update()
	if !raycast.is_colliding():
		print("no collision")
		return 0
	var collider = raycast.get_collider()
	if collider.has_method("damage") and !collider.dead:
		print("damaged")
		collider.damage(damage)
		if collider.dead:
			print("dead")
			bounty += collider.value
		if collider.critical == true:
			return 2
		return 1
	return -1

func get_ammo_cost():
	return ammo_cost
