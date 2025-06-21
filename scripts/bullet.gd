extends MeshInstance3D

const SPEED = 45

func _process(delta):
	position += self.transform.basis * Vector3(0,0, -SPEED) * delta
