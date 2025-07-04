extends Node3D

const ENEMY_LAYER = 31
@export var shoot_time = 0.3
@export var damage = 5
@export var ammo_cost = 5

@onready var raycast = $RayCast3D
@onready var bullet_scene = load("res://scenes/bullet.tscn")

var bounty = 0

func shoot(line_of_sight_raycast):
	$AnimationPlayer.play("shoot")
	var bullet = bullet_scene.instantiate()
	get_tree().root.add_child(bullet);
	bullet.global_transform = raycast.global_transform
	bullet.look_at(bullet.to_global(line_of_sight_raycast.target_position))
	bullet.scale = Vector3.ONE;
	
	line_of_sight_raycast.force_raycast_update()
	if !line_of_sight_raycast.is_colliding():
		print("no collision")
		return 0
	var collider = line_of_sight_raycast.get_collider()
	if collider is CollisionObject3D and collider.get_collision_layer_value(ENEMY_LAYER):
		if collider.has_method("damage") and "dead" in collider:
			if !collider.dead:
				collider.damage(damage)
				if collider.dead:
					print("dead")
					bounty += collider.value
				if collider.critical == true:
					return 2
				return 1
			else:
				push_error("Collider isn't an enemy but is on the enemy layer (31)! ", collider)
	return -1

func get_ammo_cost():
	return ammo_cost
