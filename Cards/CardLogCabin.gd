extends Card
class_name CardLogCabin

func _ready():
	info="""木屋
	\u25cf花费3木头使用。选择一个可建造的位置，放置为场景
	\u25cf每回合结束时，获得1点鱼
	\u25cf鱼储量+3，木头储量+3
	【建筑】"""

func use():
	# 检查使用条件
	if GameManager.wood < 3:
		GameManager.set_prompt("木头不够用了")
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
		return
	# 开始发挥效果
	GameManager.finish_inspect_card()
	GameManager.set_inspect_permission(false)
	
	GameManager.set_prompt("选择一个地面位置放置为场景")
	for g in GameManager.grid_pivot.get_children():
		if GameManager.check_can_build_at(g.x,g.y):
			g.set_pattern_color(Color.green)
			g.set_pattern_index(true)
	# 等待选择			
	var result = yield(GameManager,"table_grid_pressed")
	if GameManager.check_can_build_at(result[0],result[1]):
		#选择成功
		GameManager.move_card_to_scene(self,result[0],result[1])
		GameManager.wood -= 3
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
			
		GameManager.set_inspect_permission(true)

# 激活场上的这张卡片
func activate():
	pass

func on_end_phase():
	GameManager.fish += 1
	pass


