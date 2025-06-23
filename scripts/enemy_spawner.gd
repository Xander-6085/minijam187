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
	print("starting wave ", wave_num);
	var wave: Wave = $Waves.get_children()[wave_num]
	for subwave in wave.subwaves:
		print("Spawning subwave: ", subwave)
		await run_subwave(subwave)
		print("Subwave spawned!")
		await get_tree().create_timer(subwave.delay).timeout

func run_subwave(subwave: SubWave):
	var spawned = false
	var spawners = %Spawners.get_children()
	spawners.shuffle()
	while !spawned:
		for spawner in spawners:
			if spawned or !spawner.unlocked:
				continue
			if spawner.get_node("SpawnArea").has_overlapping_bodies():
				var foo = spawner.get_node("SpawnArea").get_overlapping_bodies()
				continue # choose another spawner
			
			for i in range(0, subwave.number_to_spawn):
				var enemy = spawn_enemy(subwave.enemy_type)
				enemy.player = %Player
				get_tree().root.get_child(0).add_child(enemy)
				enemy.global_position = spawner.random_point_in_spawn_area()
			spawned = true

		if not spawned: # all spawners occupied- don't waste cpu cycles in the while loop
			await get_tree().create_timer(0.5).timeout
		
		
	
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
