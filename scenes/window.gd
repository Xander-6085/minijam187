extends Node3D

@onready var plank3 = $Plank3/StaticBody3D
@onready var plank2 = $Plank2/StaticBody3D
@onready var plank1 = $Plank1/StaticBody3D

var plank_count = 3
var fix_timer = -1
var damage_timer = -1
@export var fix_speed = 1.5
@export var damage_speed = 1.25

func _process(delta):
	if fix_timer != -1:
		fix_timer += delta # countdown
		if fix_timer > fix_speed:
			fix_timer = -1
	if damage_timer != -1:
		damage_timer += delta # countdown
		if damage_timer > damage_speed:
			damage_timer = -1

func random_point_in_spawn_area():
	var area = $ViableSpawnArea/CollisionShape3D
	var shape = area.shape
	var origin = area.global_position
	var size = shape.extents
	return origin + Vector3(randf_range(-size.x, size.x), 0, randf_range(-size.z, size.z))

func fix():
	if fix_timer == -1 and plank_count < 3:
		plank_count += 1
		fix_timer = 0
		update_planks()
		return true
	return false
	
func damage(amount):
	if damage_timer == -1 and plank_count > 0:
		plank_count -= 1
		damage_timer = 0
		update_planks()
	
func start_fixing():  # first board doesn't get instantly fixed
	fix_timer = 0
	
func start_damaging():  # first board doesn't get instantly destroyed
	damage_timer = 0
	
func stop_fixing():  # reset progress on uncrouch
	fix_timer = -1
	
func stop_damaging():  # reset progress if enemies stop attacking
	damage_timer = -1
	
func update_planks():
	match plank_count:
		3:
			plank3.show_all()
			plank2.show_all()
			plank1.show_all()
		2:
			plank3.hide_all()
			plank2.show_all()
			plank1.show_all()
		1:
			plank3.hide_all()
			plank2.hide_all()
			plank1.show_all()
		_:
			plank3.hide_all()
			plank2.hide_all()
			plank1.hide_all()
