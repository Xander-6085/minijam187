extends Control


func _ready() -> void:
	$StartButton.connect("button_up", self.start_game)
	$QuitButton.connect("button_up", self.quit_game)
	
func start_game():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func quit_game():
	get_tree().quit()
