extends Node3D

var plank_count = 3
@onready var plank3 = $Plank3/StaticBody3D
@onready var plank2 = $Plank2/StaticBody3D
@onready var plank1 = $Plank1/StaticBody3D

func damage():
	plank_count -= 1
	update_planks()
	
func fix():
	plank_count += 1
	update_planks()
	
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
