extends Node3D

const ENEMY_LAYER = 31
@export var shoot_time = 1.0
@export var damage = 5
@export var ammo_cost = 10

@onready var bullet_scene = load("res://scenes/bullet.tscn")

var bounty = 0

func shoot(line_of_sight_raycast):
	var success = -1
	$AnimationPlayer.stop()
	$AnimationPlayer.play("shoot")
	for cast in $Raycasts.get_children():
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet);
		bullet.global_transform = cast.global_transform
		bullet.look_at(bullet.to_global(cast.target_position))
		bullet.scale = Vector3.ONE;
		print(bullet)
		
		cast.force_raycast_update()
		if !cast.is_colliding():
			print("no collision")
			success = max(success, 0)
		var collider = cast.get_collider()
		if collider is CollisionObject3D and collider.get_collision_layer_value(ENEMY_LAYER):
			if collider.has_method("damage") and "dead" in collider:
				if !collider.dead:
					collider.damage(damage)
					if collider.dead:
						print("dead")
						bounty += collider.value
					if collider.critical == true:
						success = 2
					success = max(success, 1)
				else:
					push_error("Collider isn't an enemy but is on the enemy layer (31)! ", collider)
	return success

func get_ammo_cost():
	return ammo_cost
