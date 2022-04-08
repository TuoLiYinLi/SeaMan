extends Card
class_name CardTower

var activated_times: = 0
var activate_limit: = 1

func _ready():
	info="""哨塔
	\u25cf花费2点鱼，2点木头使用，选择一个可建造的位置，放置这张卡作为场景
	\u25cf每回合可以激活1次，花费1鱼。选择一个范围2以内的角色，将其破坏
	【建筑】"""

func use():
	# 检查使用条件
	if GameManager.fish < 2 or GameManager.wood < 2:
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
		GameManager.fish -= 2
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

func filter(card:Card)->bool:
	return card in GameManager.chara_cards_all() and GameManager.distance_between(card.grid_x,card.grid_y,grid_x,grid_y) <= 2

var filter_ref:FuncRef = funcref(self,"filter")

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
		
	if GameManager.filter_cards(GameManager.chara_cards_all(),filter_ref).empty():
		GameManager.set_prompt("没有可选择的卡片")
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
		return
	# 开始发挥效果
	GameManager.finish_inspect_card()
	GameManager.set_state_select_card()
	
	GameManager.set_prompt("选择一个范围2以内的角色")
	for c in GameManager.filter_cards(GameManager.chara_cards_all(),filter_ref):
		GameManager.highlight_card(c)
	# 等待选择
	var result = yield(GameManager,"card_pressed")
	if filter(result):
		#选择成功
		GameManager.fish -= 1
		GameManager.reset_highlight_card()
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
		GameManager.reset_highlight_card()
		GameManager.set_state_inspect()
		
# 开始阶段时
func on_start_phase():
	activated_times = 0
	return
