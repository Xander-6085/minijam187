extends MeshInstance3D

const SPEED = 50

func _ready() -> void:
	queue_die()
	
func queue_die():
	await get_tree().create_timer(0.1).timeout
	self.queue_free()
	
func _process(delta):
	position += self.transform.basis * Vector3(0,0, -SPEED) * delta
	if $Area3D.has_overlapping_bodies():
		self.queue_free()
	
	
