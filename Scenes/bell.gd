extends Node2D
class_name Bell

var bell_body:RigidBody2D

var d:float = 1
var can_finish_control:bool = false

func _ready():
	bell_body = $body_rb2d
	if !bell_body:
		print_debug("error: bell_body not found")

func ring():
	bell_body.apply_torque_impulse(d * 60000)
	if can_finish_control:
		GameManager.emit_signal("control_finished")
	d = - d
	

# 铃铛撞击时触发
func _on_ball_rb2d_body_entered(body):
	# print("bell sound")
	return
