extends Card
class_name CardSlime

func _ready():
	info = """史莱姆
	\u25cf当抽到时，自动使用，随机选择一个地面边缘位置放置为角色，之后抽一张卡片
	\u25cf当回合结束时，破坏所在位置的卡片，或者移动距离1
	【怪物】"""

# 当抽到这张卡片时
func on_draw():
	var result = use()
	if result is GDScriptFunctionState:
		yield(result,"completed")


# 使用手中的这张卡片
func use():
	GameManager.finish_inspect_card()
	
	var a:Array = GameManager.grids_ground_border()
	if a.empty():
		GameManager.move_card_to_discard_pile(self)
	else:
		var p = a[randi() % a.size()]
		GameManager.move_card_to_chara(self,p.x,p.y)
	
	var result = GameManager.draw_card()
	if result is GDScriptFunctionState:
		yield(result,"completed")
	
# 回合结束时破坏所在位置的场景并移动范围1
func on_end_phase():
	var scene = GameManager.scene_card_at(grid_x,grid_y)
	if scene:
		var result = GameManager.destroy_card(scene)
		if result is GDScriptFunctionState:
			yield(result,"completed")
		return
	
	for card in GameManager.scene_cards_sort_distance_to(grid_x,grid_y):
		if !GameManager.chara_card_at(card.grid_x,card.grid_y):
			if grid_x < card.grid_x and !GameManager.chara_card_at(grid_x + 1, grid_y):
				GameManager.move_card_to_chara(self,grid_x + 1, grid_y)
				return
			elif grid_x > card.grid_x and !GameManager.chara_card_at(grid_x - 1, grid_y):
				GameManager.move_card_to_chara(self,grid_x - 1, grid_y)
				return
			elif grid_y < card.grid_y and !GameManager.chara_card_at(grid_x, grid_y + 1):
				GameManager.move_card_to_chara(self,grid_x, grid_y + 1)
				return
			elif grid_y > card.grid_y and !GameManager.chara_card_at(grid_x, grid_y - 1):
				GameManager.move_card_to_chara(self,grid_x, grid_y - 1)
				return
			
