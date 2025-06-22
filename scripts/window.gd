extends Node3D

func spawn(entities):
	for entity in entities:
		entity.global_position = self.global_position
		get_tree().root.add_child(entity) # TODO : Space them apart
