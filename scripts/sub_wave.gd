extends Resource

class_name SubWave

@export var delay: float;
@export var enemy_type: EnemySpawner.EnemyType;
@export var number_to_spawn: int;
@export var spawner: NodePath;

func _init(delay=0.0, enemy_type=EnemySpawner.EnemyType.DEMON_1, number_to_spawn=0, spawner=null):
	self.delay = delay
	self.enemy_type = enemy_type
	self.number_to_spawn = number_to_spawn;
	assert(spawner != null);
	self.spawner = spawner;
	
func spawn():
	pass
