extends Card
class_name CardMuddyPath


func _ready():
	info = """泥泞小路
	\u25cf无花费使用，选择一个地面位置放置为场景
	【建筑】"""

# 使用手中的这张卡片
func use():
	# 产生效果
	GameManager.set_state_select_grid()
	GameManager.finish_inspect_card()
	GameManager.set_prompt("选择一个地面位置放置为场景")
	
	for g in GameManager.grid_pivot.get_children():
		if filter_grid(g):
			g.set_pattern_color(Color.green)
			g.set_pattern_index(true)
			
	var result = yield(GameManager,"table_grid_pressed")
	if filter_grid(GameManager.grid_at(result[0],result[1])):
		GameManager.move_card_to_scene(self,result[0],result[1])
		
	else:
		GameManager.set_prompt("选择无效")
		yield(get_tree().create_timer(0.5),"timeout")
			
	GameManager.reset_highlight_grid()	
	GameManager.set_prompt("")
	GameManager.set_state_inspect()
	
func filter_grid(g:TableGrid)->bool:
	return !g.flag_sea and !GameManager.scene_card_at(g.x,g.y) and GameManager.check_can_build_at(g.x,g.y)

