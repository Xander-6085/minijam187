extends MeshInstance3D

const SPEED = 200

func _process(delta):
	position += self.transform.basis * Vector3(0,0, -SPEED) * delta
	if $Area3D.has_overlapping_bodies():
		self.queue_free()
	
	
