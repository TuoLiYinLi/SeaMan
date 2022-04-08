extends Card
class_name CardPit


func _ready():
	info = """坑
	\u25cf当抽到时，自动使用，必须选择一个有角色且没有场景的地面位置，将那里的角色破坏，此卡放置在那里，之后抽一张卡片
	"""

# 当抽到这张卡片时
func on_draw():
	var result = use()
	if result is GDScriptFunctionState:
		yield(result,"completed")
	

# 使用手中的这张卡片
func use():
	
	var cards:Array = GameManager.filter_cards(GameManager.chara_cards_all(),filter_ref)
	if cards.empty():
		GameManager.set_prompt("没有适用的位置")
		GameManager.move_card_to_discard_pile(self)
		yield(get_tree().create_timer(0.5),"timeout")
		GameManager.set_prompt("")
		var result = GameManager.draw_card()
		if result is GDScriptFunctionState:
			yield(result,"completed")
		return
		
	# 产生效果
	GameManager.set_state_select_grid()
	GameManager.finish_inspect_card()
	GameManager.set_prompt("选择一个有角色且没有场景的地面位置")
	
	for c in cards:
		var g:TableGrid = GameManager.grid_at(c.grid_x,c.grid_y)
		GameManager.highlight_grid(g)
		
	while true:
		var result = yield(GameManager,"table_grid_pressed")
		if filter(GameManager.chara_card_at(result[0],result[1])):
			GameManager.destroy_card(GameManager.chara_card_at(result[0],result[1]))
			GameManager.move_card_to_scene(self, result[0], result[1])
			break
		else:
			GameManager.set_prompt("选择无效，重新选择")
			yield(get_tree().create_timer(0.5),"timeout")
			GameManager.set_prompt("选择一个有角色且没有场景的地面位置")
			
	GameManager.reset_highlight_grid()
		
	GameManager.set_prompt("")
	GameManager.set_state_inspect()
	
	var result = GameManager.draw_card()
	if result is GDScriptFunctionState:
		yield(result,"completed")
	
	
var filter_ref:FuncRef = funcref(self,"filter")

func filter(card:Card)->bool:
	if !card:
		return false
	return card in GameManager.chara_cards_all() and !GameManager.scene_card_at(card.grid_x, card.grid_y) and !GameManager.grid_at(card.grid_x, card.grid_y).flag_sea 
