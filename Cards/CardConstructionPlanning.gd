extends Card
class_name CardConstructionPlanning


func _ready():
	info="""建筑规划
	\u25cf花费1点鱼使用，选择一个地面位置放置为场景
	\u25cf可以激活，将此卡破坏
	【建筑】"""

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
	
	GameManager.set_prompt("选择一个地面位置放置为场景")
	for g in GameManager.grid_pivot.get_children():
		if !GameManager.scene_card_at(g.x,g.y) and !g.flag_sea:
			GameManager.highlight_grid(g)
	# 等待选择
	var result = yield(GameManager,"table_grid_pressed")
	if !GameManager.scene_card_at(result[0],result[1]) and !GameManager.grid_at(result[0],result[1]).flag_sea:
		#选择成功
		GameManager.move_card_to_scene(self,result[0],result[1])
		GameManager.fish -= 1
		GameManager.reset_highlight_grid()
		GameManager.set_prompt("")
	else:
		#选择失效
		GameManager.set_prompt("选择无效")
		GameManager.reset_highlight_grid()
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
			
	GameManager.set_state_inspect()
	
func activate():
	# 开始发挥效果
	GameManager.destroy_card(self)
