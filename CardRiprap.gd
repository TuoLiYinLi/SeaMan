extends Card
class_name CardRiprap


func _ready():
	info="""乱石堆
	\u25cf花费1点鱼，2点木头使用，选择一个可建造的位置，放置这张卡作为场景
	\u25cf手牌上限+1
	"""

func use():
	# 检查使用条件
	if GameManager.fish < 1 or GameManager.wood < 2:
		GameManager.set_prompt("资源不够用了")
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
		return
	# 开始发挥效果
	GameManager.set_state_select_grid()
	GameManager.finish_inspect_card()
	
	GameManager.set_prompt("选择一个可建造的位置放置为场景")
	for g in GameManager.grid_pivot.get_children():
		if GameManager.check_can_build_at(g.x,g.y):
			g.set_pattern_color(Color.green)
			g.set_pattern_index(true)
	# 等待选择			
	var result = yield(GameManager,"table_grid_pressed")
	if GameManager.check_can_build_at(result[0],result[1]):
		#选择成功
		GameManager.move_card_to_scene(self,result[0],result[1])
		GameManager.fish -= 1
		GameManager.wood -= 2
		for g in GameManager.grid_pivot.get_children():
			g.set_pattern_color(Color.white)
			g.set_pattern_index(false)
		GameManager.set_prompt("")
	else:
		#选择失效
		GameManager.set_prompt("选择无效")
		for g in GameManager.grid_pivot.get_children():
			g.set_pattern_color(Color.white)
			g.set_pattern_index(false)
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
			
	GameManager.set_state_inspect()

