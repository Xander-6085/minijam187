extends Node

class_name EnemySpawner;

enum EnemyType {
	DEMON_1,
	DOG,
	DEMON_2,
	BIG_DEMON
}

static var enemy_types = [
	load("res://scenes/Demon.tscn"),
	load("res://scenes/dog.tscn"),
	load("res://scenes/StrongDemon.tscn"),
	load("res://scenes/BigDemon.tscn"),
]

var wave_num = -1
var new_wave_timer = -1
var total_waves = 1

@export var new_wave_time = 5
@onready var player = %Player

func _ready() -> void:
	total_waves = len($Waves.get_children())

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		boss()

	var enemies = get_tree().get_nodes_in_group("enemies")
	if new_wave_timer == -1:
		print(enemies)
		if len(enemies) == 0 and wave_num < total_waves-1:
			print("wave_num: ", wave_num)
			wave_num += 1
			run_wave(wave_num)
		new_wave_timer = 0
	if new_wave_timer != -1:
		new_wave_timer += delta # countdown
		if new_wave_timer > new_wave_time: # we can shoot again
			new_wave_timer = -1

func run_wave(wave_num: int):
	print("starting wave ", wave_num);
	player.round_text.text = str("Round ", wave_num + 1)
	var wave: Wave = $Waves.get_children()[wave_num]
	for subwave in wave.subwaves:
		player.enemies += subwave.number_to_spawn
		
	for subwave in wave.subwaves:
		print("Spawning subwave: ", subwave)
		await run_subwave(subwave)
		print("Subwave spawned!")
		await get_tree().create_timer(subwave.delay).timeout
		
func boss():
	var boss = enemy_types[3].instantiate()
	boss.player = %Player
	boss.scale = Vector3(4,4,4);
	get_tree().root.add_child(boss)
	boss.global_transform = %BossSpawn.global_transform
	

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
		EnemyType.DEMON_2:
			return enemy_types[2].instantiate()
		_:
			assert(1 == 0);
			return enemy_types[0].instantiate()

	# 1. 
	# 2. spawn N demons until window full
	# 3. wait?
	# 4. repeat
