extends Node2D
class_name Bell

var bell_body:RigidBody2D

var d:float = 1

func _ready():
	bell_body = $body_rb2d
	if !bell_body:
		print_debug("error: bell_body not found")

func ring():
	bell_body.apply_torque_impulse(d * 60000)
	d = -d
	
