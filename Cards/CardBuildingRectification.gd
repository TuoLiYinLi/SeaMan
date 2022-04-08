extends Card
class_name CardBuildingRectification

var first_selected_card:Card = null

func _ready():
	info = """建筑整改
	\u25cf花费1点鱼，1点木头使用，选择两个“建筑”卡片互换位置，丢弃此卡"""

func use():
	# 检查使用条件
	if GameManager.fish < 1 or GameManager.wood < 1:
		GameManager.set_prompt("资源不够用了")
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
		return
	var count:=0
	for s in GameManager.scene_cards_all():
		if GameManager.check_card_tag(s,"建筑"):
			count += 1
			if(count>=2):break
	if count<2:			
		GameManager.set_prompt("没有可选择的卡片")
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
		return
	# 开始发挥效果
	GameManager.finish_inspect_card()
	GameManager.set_state_select_card()
	
	GameManager.set_prompt("选择第一个“建筑”卡片")
	for c in GameManager.scene_cards_all():
		if GameManager.check_card_tag(c,"建筑"):
			GameManager.highlight_card(c)
	# 等待选择
	var result = yield(GameManager,"card_pressed")
	if GameManager.check_card_tag(result,"建筑"):
		#选择成功
		first_selected_card = result
		GameManager.set_prompt("选择第二个“建筑”卡片")
		
		GameManager.reset_highlight_card()
		for c in GameManager.scene_cards_all():
			if GameManager.check_card_tag(c,"建筑") and c != first_selected_card:
				GameManager.highlight_card(c)
		# 等待第二次选择
		result = yield(GameManager,"card_pressed")
		if GameManager.check_card_tag(result,"建筑") and result != first_selected_card:
			# 选择成功
			GameManager.fish -= 1
			GameManager.wood -= 1
			GameManager.move_card_to_discard_pile(self)
			var x1 = first_selected_card.grid_x
			var y1 = first_selected_card.grid_y
			GameManager.move_card_to_scene(first_selected_card, result.grid_x, result.grid_y)
			GameManager.move_card_to_scene(result, x1, y1)
			
			GameManager.reset_highlight_card()
			GameManager.set_prompt("")
			GameManager.set_state_inspect()
			return

		#选择失效
	GameManager.set_prompt("选择无效")
	GameManager.reset_highlight_card()
	yield(get_tree().create_timer(0.5),"timeout")
	GameManager.set_prompt("")
	GameManager.set_state_inspect()
			
	
