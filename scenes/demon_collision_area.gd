extends Area3D
@onready var demon = $".."

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(other):
	if other is Angel:
		demon.attacking_player = other
	if other is Plank:
		demon.attacking_window = other.window

func _on_body_exited(other):
	if other == demon.attacking_player:
		demon.attacking_player = null
	if other == demon.attacking_window:
		demon.attacking_window = null
