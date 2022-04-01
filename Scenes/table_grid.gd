extends Node2D
class_name TableGrid

const sea = preload("res://Textures/sea.png")
const land = preload("res://Textures/land.png")

var flag_sea := false

export(int) var x = 0
export(int) var y = 0

func set_land():
	flag_sea = false
	$pattern.texture = land
	
func set_sea():
	$pattern.texture = sea
	flag_sea = true

func set_pattern_color(color:Color):
	$pattern.modulate = color

func set_pattern_index(front:bool):
	if front:
		$pattern.z_index = 1
	else:
		$pattern.z_index = 0
