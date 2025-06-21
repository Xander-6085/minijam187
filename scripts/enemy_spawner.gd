extends Node3D

class_name EnemySpawner;

enum EnemyType {
	DEMON_1,
	DOG,
}

@export var enemy_counts = {
	EnemyType.DEMON_1: 0,
	EnemyType.DOG: 0,
};

@onready var enemy_types = [
	load("res://scenes/Demon.tscn"),
	load("res://scenes/Demon.tscn")
]

func run_wave(wave_num: int):
	var wave: Wave = $Waves.get_children()[wave_num]
	for subwave in wave.subwaves:
		subwave.spawn()
		print("Spawning subwave: ", subwave)
		await get_tree().create_timer(subwave.delay).timeout
		print("Subwave delay over!")
	

func _process(delta: float) -> void:
	pass
	# 1. 
	# 2. spawn N demons until window full
	# 3. wait?
	# 4. repeat
