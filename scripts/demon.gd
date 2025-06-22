extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

@export var acceleration = 10
@export var speed = 2

func _ready():
	nav_agent.max_speed = 5

func _process(delta: float) -> void:
	var player = %Player
	if player:
		nav_agent.target_position = player.global_position
	
	var direction = nav_agent.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, acceleration * delta)
	look_at(nav_agent.target_position)
	move_and_slide()
	
