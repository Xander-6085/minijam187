extends Control

func show_popup():
	self.visible = true
	await get_tree().create_timer(3).timeout
	self.visible = false
