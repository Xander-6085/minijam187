extends Resource

class_name SubWave

@export var delay: float;
@export var enemy_type: EnemySpawner.EnemyType;
@export var number_to_spawn: int;

func _init(delay=0.0, enemy_type=EnemySpawner.EnemyType.DEMON_1, number_to_spawn=0):
	self.delay = delay
	self.enemy_type = enemy_type
	self.number_to_spawn = number_to_spawn;
