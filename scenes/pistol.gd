extends Node3D
const SHOOT_TIME = 0.3

@onready var barrel = $RayCast3D

func shoot():
	return 1

func get_ammo_cost():
	return 5
