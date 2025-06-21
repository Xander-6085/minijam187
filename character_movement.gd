extends CharacterBody3D
class_name Angel

@export var speed = 5.0
@export var acceleration = 4.0
@export var mouse_sensitivity = 0.0015
@export var rotation_speed = 12.0
@export var starting_light = 0.0
@export var max_light = 100.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var model = $Rig
@onready var interact_cast = $Camera3D/interact_cast
@onready var interact_text = $CanvasLayer/BoxContainer/interact_text
@onready var active_gun = $Camera3D/active_gun

var light : float = max_light:
	get:
		return light
	set(value):
		light = clamp(value, 0, max_light)
		var v = light / max_light;
		v = lerp(1, -1, v);
		var light_bar_mat = %LightBar.material
		light_bar_mat.set_shader_parameter("cutoff", v);
		%LightBar.material = light_bar_mat;
		
		

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		

func _physics_process(delta):
	interact_text.hide()
	if interact_cast.is_colliding():
		var target = interact_cast.get_collider()
		if target != null and target.has_method("interact") and target.has_method("get_interact_text"):
			interact_text.text = target.get_interact_text()
			interact_text.show()
			if Input.is_action_just_pressed("interact"):
				target.interact()
	
	velocity.y += -gravity * delta
	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed

	move_and_slide()

func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and active_gun.can_shoot:
		active_gun.shoot()
		
	print_debug(%LightBar.material.get_shader_parameter("cutoff"))
	


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
