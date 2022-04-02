extends TextureButton

var card:Card

func _ready():
	card = get_parent() as Card
	if !card:
		print_debug("error: card not found")

func _pressed():
	if GameManager.get_inspect_area_card() == card:
		card.use()
	else:
		inspect_this_card()
	

# 进行检视
func inspect_this_card():
		GameManager.inspect_card(card)

func _process(delta):
	# 展示下方卡片
	if is_hovered() and card.get_parent() == GameManager.scene_card_pivot and GameManager.flag_inspect_state:
		card.z_index = 1
	else:
		card.z_index = 0
	
