extends StaticBody3D

@onready var demon = $".."
@onready var value = demon.value

var critical = true
var dead = false

func damage(amount):
	print("crit")
	demon.damage(amount * 2)
	dead = demon.dead
