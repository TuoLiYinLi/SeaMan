extends Card
class_name CardWoodsGrowth


func _ready():
	info = """林地生长
	\u25cf当抽到时，自动使用，将一张“林地”添加到弃牌堆，之后抽一张卡片
	"""

# 当抽到这张卡片时
func on_draw():
	var result = use()
	if result is GDScriptFunctionState:
		yield(result,"completed")


# 使用手中的这张卡片
func use():
	GameManager.move_card_to_discard_pile(GameManager.create_card(GameManager.card_woods))
	GameManager.discard_card(self)
	
	var result = GameManager.draw_card()
	if result is GDScriptFunctionState:
		yield(result,"completed")

