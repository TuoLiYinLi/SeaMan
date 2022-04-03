extends Card
class_name CardLoggingCamp

# 已经激活的次数
var activated_times: = 0
# 激活次数上限
var activate_limit: = 1
	

func _ready():
	info="""伐木场
	\u25cf花费3点鱼使用，选择一个地面位置，放置为场景
	\u25cf每回合可以激活1次，花费1点鱼，选择一张范围2内的“木头”卡片，将其破坏，并获得1木头
	\u25cf木头储量+1
	【建筑】"""

func use():
	# 检查使用条件
	if GameManager.fish < 3:
		GameManager.set_prompt("鱼不够用了")
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
		return
	# 开始发挥效果
	GameManager.finish_inspect_card()
	GameManager.set_state_select_grid()
	
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
		GameManager.fish -= 3
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

func check_target_card(card:Card)->bool:
	return GameManager.distance_between(card.grid_x,card.grid_y,grid_x,grid_y) <= 2 and GameManager.check_card_tag(card,"木头") and card != self

func get_all_target_cards()->Array:
	var out_array:Array = []
	var cards = GameManager.scene_cards_all()
	cards.append_array(GameManager.chara_cards_all())
	for c in cards:
		if check_target_card(c):
			out_array.append(c)
	return out_array
	
func activate():
	# 检查使用条件
	if activated_times >= activate_limit:
		GameManager.set_prompt("激活次数不够了")
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
		return
	if GameManager.fish < 1:
		GameManager.set_prompt("鱼不够用了")
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
		return
	if get_all_target_cards().empty():
		GameManager.set_prompt("没有可选择的卡片")
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
		return
	# 开始发挥效果
	GameManager.finish_inspect_card()
	GameManager.set_state_select_card()
	
	GameManager.set_prompt("选择一张【木头】卡片")
	for c in get_all_target_cards():
		c.card_border.visible = true
	# 等待选择
	var result = yield(GameManager,"card_pressed")
	if check_target_card(result):
		#选择成功
		GameManager.fish -= 1
		GameManager.wood += 1
		for c in GameManager.scene_cards_in_distance(grid_x,grid_y,1):
			if c is CardWorkingTable:
				GameManager.wood += 1
		activated_times += 1
		for c in GameManager.cards_all():
			c.card_border.visible = false
		GameManager.set_prompt("")
		GameManager.set_state_inspect()
		
		var result1 = GameManager.destroy_card(result)
		if result1 is GDScriptFunctionState:
			yield(result1,"completed")
	else:
		#选择失效
		GameManager.set_prompt("选择无效")
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
		for c in GameManager.cards_all():
			c.card_border.visible = false
		GameManager.set_state_inspect()
		
# 开始阶段时
func on_start_phase():
	activated_times = 0
	return
