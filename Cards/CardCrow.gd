extends Card
class_name CardCrow


func _ready():
	info = """林地生长
	\u25cf当抽到时，自动使用，必须选择一张弃牌堆的卡片，将其添加（抽取）到手牌，丢弃此卡
	"""

# 当抽到这张卡片时
func on_draw():
	var result = use()
	if result is GDScriptFunctionState:
		yield(result,"completed")


# 使用手中的这张卡片
func use():
	# 发挥效果
	GameManager.set_prompt("选择一张卡片")
	GameManager.set_state_select_card()
	
	GameManager.extra_card_panel.set_blackout_display(true)
	GameManager.set_state_select_specific_cards(GameManager.discard_pile_cards_all())
	var result = yield(GameManager,"card_pressed")
	GameManager.set_prompt("")
	GameManager.extra_card_panel.set_blackout_display(false)
	GameManager.set_state_lock()
	
	GameManager.move_card_to_hand(result)
	GameManager.discard_card(self)
	
	
	result = result.on_draw()
	if result is GDScriptFunctionState:
		yield(result,"completed")


