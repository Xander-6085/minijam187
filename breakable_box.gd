extends CSGBox3D

@export var critical = false;
@export var hp = 15;
@export var value = 10;
@export var death_time = 5;
var dead = false;

func damage(amount):
	hp -= amount
	if hp <= 0:
		dead = true
		await get_tree().create_timer(death_time).timeout
		queue_free()
