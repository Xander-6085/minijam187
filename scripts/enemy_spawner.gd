extends Node

class_name EnemySpawner;

enum EnemyType {
	DEMON_1,
	DOG,
}

static var enemy_types = [
	load("res://scenes/Demon.tscn"),
	load("res://scenes/Demon.tscn")
]

func run_wave(wave_num: int):
	print("starting wave!");
	var wave: Wave = $Waves.get_children()[wave_num]
	for subwave in wave.subwaves:
		print("Spawning subwave: ", subwave)
		run_subwave(subwave)
		await get_tree().create_timer(subwave.delay).timeout
		print("Subwave delay over!")
	
func run_subwave(subwave: SubWave):
	var enemies = []
	for i in range(0, subwave.number_to_spawn):
		var enemy = spawn_enemy(subwave.enemy_type)
		enemies.append(enemy)
	%Spawners.get_child(subwave.spawner_idx).spawn(enemies)
	
	
	
func spawn_enemy(enemy_type: EnemyType) -> Node3D:
	match enemy_type:
		EnemyType.DEMON_1:
			return enemy_types[0].instantiate()
		EnemyType.DOG:
			return enemy_types[1].instantiate()
		_:
			assert(1 == 0);
			return enemy_types[0].instantiate()
		

func _process(delta: float) -> void:
	pass
	# 1. 
	# 2. spawn N demons until window full
	# 3. wait?
	# 4. repeat
