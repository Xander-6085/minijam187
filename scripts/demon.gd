extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

@export var acceleration = 10
@export var speed = 2
@export var attack = 10
@export var critical = false
@export var hp = 15
@export var value = 10
@export var death_time = 5

var dead = false
var attacking_player = null
var attacking_window = null
var player = null

func _process(delta: float) -> void:
	print("Dog yee")
	if not dead:
		if player == null:
			player = %Player
		if player != null:
			nav_agent.target_position = player.global_position
		var direction = nav_agent.get_next_path_position() - global_position
		direction = direction.normalized()
		velocity = velocity.lerp(direction * speed, acceleration * delta)
		
		look_at(nav_agent.target_position)
		rotation.x = 0
		rotation.z = 0
		move_and_slide()
		if attacking_player != null:
			attacking_player.damage(attack)
		if attacking_window != null:
			attacking_window.damage(attack)

func damage(amount):
	hp -= amount
	if hp <= 0:
		dead = true
		
		var t := create_tween()
		$body_collider.disabled = true
		$head/head_collider.disabled = true
		var falling_direction = ((randi() & 2) - 1)
		t.tween_property(self, "rotation:z", 1.5*falling_direction, 1)
		await get_tree().create_timer(death_time).timeout
		queue_free()
