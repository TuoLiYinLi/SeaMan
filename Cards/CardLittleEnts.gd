extends Card
class_name CardLittleEnts


func _ready():
	info = """小树精
	\u25cf当抽到时，自动使用，随机选择一个地面位置放置为角色，之后抽一张卡片
	\u25cf当回合结束时，移动距离1
	【木头】"""

# 当抽到这张卡片时
func on_draw():
	var result = use()
	if result is GDScriptFunctionState:
		yield(result,"completed")


# 使用手中的这张卡片
func use():
	GameManager.finish_inspect_card()
	
	var a := []
	for _x in range(9):
		for _y in range(9):
			if !GameManager.chara_card_at(_x,_y):
				a.append(Vector2(_x,_y))
	if a.size() == 0:
		GameManager.move_card_to_discard_pile(self)
	else:
		var p = a[randi() % a.size()]
		GameManager.move_card_to_chara(self,p.x,p.y)
	
	var result = GameManager.draw_card()
	if result is GDScriptFunctionState:
		yield(result,"completed")
	
# 回合结束时破坏所在位置的场景并移动范围1
func on_end_phase():
	
	var a := []
	for _x in range(9):
		for _y in range(9):
			if !GameManager.chara_card_at(_x,_y) and GameManager.distance_between(_x,_y,grid_x,grid_y) == 1:
				a.append(Vector2(_x,_y))
	
	if a.size() == 0:
		return
	else:
		var p = a[randi() % a.size()]
		GameManager.move_card_to_chara(self,p.x,p.y)
	
