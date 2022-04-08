extends Card
class_name CardTide


func _ready():
	info = """海潮
	\u25cf当抽到时，自动使用，随机选择一个地面边缘位置，将那里的角色和场景破坏，此位置变为水域，丢弃此卡，之后抽一张卡片
	【噩兆】"""

# 当抽到这张卡片时
func on_draw():
	var result = use()
	if result is GDScriptFunctionState:
		yield(result,"completed")
	

# 使用手中的这张卡片
func use():
	
	var grids:Array = GameManager.grids_border()
	if grids.empty():
		GameManager.set_prompt("没有适用的位置")
		GameManager.move_card_to_discard_pile(self)
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
		
		var result = GameManager.draw_card()
		if result is GDScriptFunctionState:
			yield(result,"completed")
		return
		
	# 产生效果
	var grid:TableGrid = grids[randi()%grids.size()]
	grid.set_sea()
	if GameManager.chara_card_at(grid.x, grid.y):
		GameManager.destroy_card(GameManager.chara_card_at(grid.x, grid.y))
		
	if GameManager.scene_card_at(grid.x, grid.y):
		GameManager.destroy_card(GameManager.scene_card_at(grid.x, grid.y))
		
	GameManager.move_card_to_discard_pile(self)
	
	var result = GameManager.draw_card()
	if result is GDScriptFunctionState:
		yield(result,"completed")
	
