extends CharacterBody3D
class_name Angel

@export var speed = 5.0
@export var acceleration = 4.0
@export var mouse_sensitivity = 0.0015
@export var rotation_speed = 12.0
@export var max_light = 100.0
@export var starting_light = 50
@export var light_from_fixing_windows = 10
@export var invuln_time = 1.5
@export var hitmarker_fadetime = 0.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var fixable_window = null
var crouched = false
var invuln_timer = -1
var hit_tween = null
var crit_tween = null

@onready var model = $Rig
@onready var interact_cast = $Camera3D/interact_cast
@onready var interact_text = $CanvasLayer/BoxContainer/interact_text
@onready var light_text = $CanvasLayer/light_text
@onready var active_gun = $Camera3D/active_gun

@onready var light : float = 0:
	get:
		return light
	set(value):
		light = clamp(value, 0, max_light)
		var v = light / max_light;
		v = lerp(0.3, -1.0, v);
		var light_bar_mat = %LightBar.material
		light_bar_mat.set_shader_parameter("cutoff", v);
		%LightBar.material = light_bar_mat;

func _ready():
	light = starting_light
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	interact_text.hide()
	if interact_cast.is_colliding():
		var target = interact_cast.get_collider()
		if target != null and target.has_method("interact") and target.has_method("get_interact_text"):
			interact_text.text = target.get_interact_text()
			interact_text.show()
			if Input.is_action_just_pressed("interact"):
				target.interact(self)
	
	velocity.y += -gravity * delta
	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed

	move_and_slide()

func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		if active_gun.can_shoot(light):
			light -= active_gun.get_ammo_cost()
			var shot_success = active_gun.shoot()
			if shot_success > 0:
				print("hit!")
				activate_hit_marker(shot_success)
				light += active_gun.claim_bounty()
			else:
				print("miss...")
	else:
		active_gun.stop_shooting()
	if Input.is_action_pressed("crouch"):
		if not crouched:
			_crouch()
			if fixable_window != null:
				fixable_window.start_fixing()
		if fixable_window != null:
			if fixable_window.fix():
				light += light_from_fixing_windows
	elif crouched:
		_uncrouch()
		if fixable_window != null:
			fixable_window.stop_fixing()
			
	if invuln_timer != -1:
		invuln_timer += delta # countdown
		if invuln_timer > invuln_time:
			invuln_timer = -1
	if Input.is_action_just_pressed("jump"):
		var foo = %LevelBase;
		foo.run_wave(0)
		
	light_text.text = str(int(light), " / ", int(max_light))


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

func is_in_window_area(window):
	fixable_window = window
	
func left_window_area():
	fixable_window = null

func _crouch():
	#Use a tween to make it smoother
	var t := create_tween()
	#Tween y axis of the collision shape to 0.5 in 0.1 second
	t.tween_property($CollisionShape3D, "scale:y", 0.5, 0.1)
	t.tween_property($Camera3D, "scale:y", 0.5, 0.1)
	crouched = true
	
func _uncrouch():
	var t := create_tween()
	t.tween_property($CollisionShape3D, "scale:y", 1, 0.1)
	t.tween_property($Camera3D, "scale:y", 1, 0.1)
	crouched = false
	
func damage(amount):
	if invuln_timer == -1:
		if light <= 0 and amount > 0:
			get_tree().quit()  # quit game for now
		light -= amount
		invuln_timer = 0

func activate_hit_marker(shot_success):
	var hit_marker = $CanvasLayer/Control/Hit
	var crit_marker = $"CanvasLayer/Control/Crit-hit"
	
	if shot_success == 1:
		if hit_tween != null:
			hit_tween.kill()
		hit_marker.modulate = Color.WHITE
		hit_tween = create_tween()
		hit_tween.tween_property(hit_marker, "modulate", Color.TRANSPARENT, hitmarker_fadetime)
	else:
		if crit_tween != null:
			crit_tween.kill()
		crit_marker.modulate = Color.LIGHT_CORAL
		crit_tween = create_tween()
		crit_tween.tween_property(crit_marker, "modulate", Color.TRANSPARENT, hitmarker_fadetime)
