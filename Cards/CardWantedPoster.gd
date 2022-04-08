extends Card
class_name CardWantedPoster


func _ready():
	info="""通缉令
	\u25cf花费1点鱼，选择一个角色，破坏它，丢弃此卡
	"""

func use():
	# 检查使用条件
	if GameManager.fish < 1:
		GameManager.set_prompt("鱼不够用了")
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
		return
	if GameManager.chara_cards_all().empty():
		GameManager.set_prompt("没有可以选择的角色")
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
		return
	# 开始发挥效果
	GameManager.finish_inspect_card()
	
	GameManager.set_prompt("选择一个角色")
	GameManager.set_state_select_card()
	
	for c in GameManager.chara_cards_all():
		GameManager.highlight_card(c)
		# 等待选择			
	var result = yield(GameManager,"card_pressed")
	if !GameManager.check_card_tag(result,"不可破坏") and result in GameManager.chara_cards_all():
		#选择成功
		GameManager.reset_highlight_card()
		GameManager.destroy_card(result)
		GameManager.move_card_to_discard_pile(self)
		GameManager.fish -= 1
		GameManager.set_prompt("")
	else:
		#选择失效
		GameManager.set_prompt("选择无效")
		GameManager.reset_highlight_card()
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
		
	GameManager.set_state_inspect()
			

