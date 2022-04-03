extends TextureButton

var card:Card

func _ready():
	card = get_parent() as Card
	if !card:
		print_debug("error: card not found")

func _pressed():
	
	if GameManager.inspect_area_card() == card and GameManager.inspect_area_pivot.card_ori_state == "hand" and GameManager.flag_state == GameManager.State.inspect:
		print("使用卡片")
		card.use()
	elif GameManager.inspect_area_card() == card and GameManager.inspect_area_pivot.card_ori_state in ["scene","chara"] and GameManager.flag_state == GameManager.State.inspect:
		print("激活卡片")
		card.activate()
	elif GameManager.flag_state == GameManager.State.inspect:
		inspect_this_card()
	elif GameManager.flag_state == GameManager.State.select_card or GameManager.flag_state == GameManager.State.select_specific_card:
		print("press card")
		GameManager.emit_signal("card_pressed", card)
	

# 进行检视
func inspect_this_card():
		GameManager.inspect_card(card)

func _process(delta):
	# 展示下方卡片
	if is_hovered() and card.get_parent() == GameManager.scene_card_pivot:
		card.z_index = 1
	else:
		card.z_index = 0
	
