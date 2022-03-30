extends Button
class_name CardButton

func set_as_card_activate_button():
	visible = true
	disabled = false
	text = "◈ 激活"

func set_as_card_use_button():
	visible = true
	disabled = false
	text = "◎ 使用"

func _pressed():
	print("card_button pressed")
