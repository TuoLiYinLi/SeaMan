extends Card
class_name CardSeal


func _ready():
	info="""封印
	\u25cf花费2点理智，从弃牌堆中选择一张卡片，剔除它和此卡
	"""

func use():
	# 检查使用条件
	if GameManager.sanity < 2:
		GameManager.set_prompt("“我会因此疯掉的……”")
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
		return
	if GameManager.discard_pile_cards_all().empty():
		GameManager.set_prompt("没有可以选择的卡片")
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
		return
	# 开始发挥效果
	GameManager.finish_inspect_card()
	
	GameManager.set_prompt("选择一张卡片")
	GameManager.set_state_select_card()
	
	GameManager.extra_card_panel.set_blackout_display(true)
	GameManager.set_state_select_specific_cards(GameManager.discard_pile_cards_all())
	var result = yield(GameManager,"card_pressed")
	GameManager.set_prompt("")
	GameManager.extra_card_panel.set_blackout_display(false)
	GameManager.set_state_lock()
	
	GameManager.move_card_to_eliminate_area(self)
	result = GameManager.eliminate_card(result)
	if result is GDScriptFunctionState:
		yield(result,"completed")
		
	GameManager.set_state_inspect()
