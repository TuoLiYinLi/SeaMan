extends Card
class_name CardSlime

# 当抽到这张卡片时
func on_draw():
	var result = use()
	if result is GDScriptFunctionState:
		yield(result,"completed")


# 使用手中的这张卡片
func use():
	GameManager.set_inspect_permission(false)
	yield(get_tree().create_timer(1.5),"timeout")
	GameManager.finish_inspect_card()
	
	var a := []
	for _x in range(9):
		for _y in range(9):
			if _x==0||_x==8||_y==0||_x==8 and !GameManager.get_chara_card_at(_x,_y):
				a.append(Vector2(_x,_y))
	if a.size() == 0:
		GameManager.move_card_to_discard_pile(self)
	else:
		var p = a[randi() % a.size()]
		GameManager.move_card_to_chara(self,p.x,p.y)
	
	GameManager.set_inspect_permission(true)
	
	var result = GameManager.draw_card()
	if result is GDScriptFunctionState:
		yield(result,"completed")
	
# 回合结束时破坏所在位置的场景并移动范围1
func on_end_phase():
	var scene = GameManager.get_scene_card_at(grid_x,grid_y)
	if scene:
		var result = GameManager.destroy_card(scene)
		if result is GDScriptFunctionState:
			yield(result,"completed")
		return
	
	for card in GameManager.find_nearst_scene(grid_x,grid_y):
		if !GameManager.get_chara_card_at(card.grid_x,card.grid_y):
			if grid_x < card.grid_x and !GameManager.get_chara_card_at(grid_x + 1, grid_y):
				GameManager.move_card_to_chara(self,grid_x + 1, grid_y)
				return
			elif grid_x > card.grid_x and !GameManager.get_chara_card_at(grid_x - 1, grid_y):
				GameManager.move_card_to_chara(self,grid_x - 1, grid_y)
				return
			elif grid_y < card.grid_y and !GameManager.get_chara_card_at(grid_x, grid_y + 1):
				GameManager.move_card_to_chara(self,grid_x, grid_y + 1)
				return
			elif grid_y > card.grid_y and !GameManager.get_chara_card_at(grid_x, grid_y - 1):
				GameManager.move_card_to_chara(self,grid_x, grid_y - 1)
				return
			
