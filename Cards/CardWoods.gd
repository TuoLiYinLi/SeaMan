extends Card
class_name CardWoods


func _ready():
	info = """林地
	*当抽到时，自动使用，必须选择一个地面位置放置为场景，之后抽一张卡片
	*当被破坏时，获得2点木头"""

# 当抽到这张卡片时
func on_draw():
	var result = use()
	if result is GDScriptFunctionState:
		yield(result,"completed")
	

# 使用手中的这张卡片
func use():
	GameManager.set_inspect_permission(false)
	GameManager.set_prompt("选择一个地面位置放置为场景")
	# yield(get_tree().create_timer(1.5),"timeout")
	GameManager.finish_inspect_card()
	
	for g in GameManager.grid_pivot.get_children():
		if filter_grid(g):
			g.set_pattern_color(Color.green)
			g.set_pattern_index(true)
			
	while true:
		var result = yield(GameManager,"table_grid_pressed")
		if filter_grid(GameManager.get_grid_at(result[0],result[1])):
			GameManager.move_card_to_scene(self,result[0],result[1])
			break
		else:
			print("选择不可用")
			
	for g in GameManager.grid_pivot.get_children():
		g.set_pattern_color(Color.white)
		g.set_pattern_index(false)
	GameManager.set_inspect_permission(true)
	GameManager.set_prompt("")
	
	var result = GameManager.draw_card()
	if result is GDScriptFunctionState:
		yield(result,"completed")
	
func filter_grid(g:TableGrid)->bool:
	return !g.flag_sea and !GameManager.get_scene_card_at(g.x,g.y)

# 当被从场上摧毁时
func on_destroy()->void:
	GameManager.wood += 2
