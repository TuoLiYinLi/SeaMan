extends TextureButton

func _pressed():
	print("press grid")
	if GameManager.flag_state == GameManager.State.select_grid:
		GameManager.emit_signal("table_grid_pressed",get_parent().x,get_parent().y)
