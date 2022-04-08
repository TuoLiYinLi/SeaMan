extends Card
class_name CardWoodcutter

var activated_times: = 0
var activate_limit: = 1

func _ready():
	info="""樵夫
	\u25cf花费1点鱼，选择一个地面位置，放置这张卡作为角色
	\u25cf每回合可激活1次，移动范围1
	\u25cf每回合结束时，消耗1点鱼，如果鱼不足则被破坏；如果所在位置有“木头”则获取1点木头
	【人类】"""

func use():
	# 检查使用条件
	if GameManager.fish < 1:
		GameManager.set_prompt("鱼不够用了")
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
		return
	# 开始发挥效果
	GameManager.finish_inspect_card()
	GameManager.set_state_select_grid()
	
	GameManager.set_prompt("选择一个地面位置放置为角色")
	for g in GameManager.grid_pivot.get_children():
		if !GameManager.chara_card_at(g.x,g.y) and !GameManager.grid_at(g.x,g.y).flag_sea:
			g.set_pattern_color(Color.green)
			g.set_pattern_index(true)
	# 等待选择			
	var result = yield(GameManager,"table_grid_pressed")
	if !GameManager.chara_card_at(result[0],result[1]) and !GameManager.grid_at(result[0],result[1]).flag_sea:
		#选择成功
		GameManager.move_card_to_chara(self,result[0],result[1])
		GameManager.fish -= 1
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


func activate():
	# 检查使用条件
	if activated_times >= activate_limit:
		GameManager.set_prompt("激活次数不够了")
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
		return
	
	# 开始发挥效果
	GameManager.finish_inspect_card()
	GameManager.set_state_select_grid()
	
	GameManager.set_prompt("选择一个地面位置进行移动")

	for g in GameManager.grids_in_distance(grid_x,grid_y,1):
		if g.x==grid_x and grid_y==g.y:
			continue
		if !GameManager.chara_card_at(g.x,g.y) and !g.flag_sea:
			GameManager.highlight_grid(g)
			
	# 等待选择
	var result = yield(GameManager,"table_grid_pressed")
	var d = GameManager.distance_between(result[0],result[1],grid_x,grid_y)
	if !GameManager.chara_card_at(result[0],result[1]) and !GameManager.grid_at(result[0],result[1]).flag_sea and d > 0 and d <= 1 :
		#选择成功
		GameManager.move_card_to_chara(self, result[0], result[1])
		activated_times += 1
		GameManager.reset_highlight_grid()
		GameManager.set_state_inspect()
		GameManager.set_prompt("")
	else:
		#选择失效
		GameManager.set_prompt("选择无效")
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.reset_highlight_grid()
		GameManager.set_state_inspect()
		GameManager.set_prompt("")


# 结束阶段时
func on_end_phase():
	# 消耗鱼
	if GameManager.fish >= 1:
		GameManager.fish -= 1
		activated_times = 0
		# 获取木头
		var scene = GameManager.scene_card_at(grid_x,grid_y)
		if scene and GameManager.check_card_tag(scene,"木头"):
			GameManager.wood += 1
	else:
		GameManager.destroy_card(self)
