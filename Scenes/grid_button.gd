extends TextureButton

func _pressed():
	if !GameManager.flag_inspect_state:
		GameManager.emit_signal("table_grid_pressed",get_parent().x,get_parent().y)
