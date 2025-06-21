extends CharacterBody3D
class_name Angel

@export var speed = 5.0
@export var acceleration = 4.0
@export var mouse_sensitivity = 0.0015
@export var rotation_speed = 12.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var gun_barrel = $Camera3D/pistol/RayCast3D

@onready var model = $Rig
@onready var bullet_scene = load("res://scenes/bullet.tscn")

const SHOOT_TIME = 0.3
var shoot_timer = -1

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	velocity.y += -gravity * delta
	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed

	move_and_slide()

func _process(delta: float) -> void:
	if shoot_timer != -1:
		shoot_timer += delta # countdown
		if shoot_timer > SHOOT_TIME: # we can shoot again
			shoot_timer = -1
		
	if Input.is_action_pressed("shoot") and shoot_timer == -1:
		var bullet = bullet_scene.instantiate()
		bullet.position = gun_barrel.global_position
		bullet.transform.basis = gun_barrel.global_transform.basis
		bullet.scale *= 10
		get_parent().add_child(bullet)
		shoot_timer = 0
		
		


func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
