extends Node2D
class_name TableGrid

const sea = preload("res://Textures/sea.png")
const land = preload("res://Textures/land.png")

export(int) var x = 0
export(int) var y = 0

func set_land():
	$pattern.texture = land
	
func set_sea():
	$pattern.texture = sea
