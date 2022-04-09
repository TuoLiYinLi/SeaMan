extends Card
class_name CardSlimeMultiplication


func _ready():
	info = """史莱姆增殖
	\u25cf当抽到时，自动使用，将一张“史莱姆”添加到弃牌堆，之后抽一张卡片
	【噩兆】"""

# 当抽到这张卡片时
func on_draw():
	var result = use()
	if result is GDScriptFunctionState:
		yield(result,"completed")


# 使用手中的这张卡片
func use():
	GameManager.move_card_to_discard_pile(GameManager.create_card(GameManager.card_slime))
	GameManager.discard_card(self)
	
	var result = GameManager.draw_card()
	if result is GDScriptFunctionState:
		yield(result,"completed")
