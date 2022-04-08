extends Card
class_name CardReading


func _ready():
	info = """阅读
	\u25cf当抽到时，自动使用，获得1点理智，丢弃此卡，之后抽一张卡片
	"""

# 当抽到这张卡片时
func on_draw():
	var result = use()
	if result is GDScriptFunctionState:
		yield(result,"completed")


# 使用手中的这张卡片
func use():
	GameManager.move_card_to_discard_pile(self)
	GameManager.sanity += 1
	var result = GameManager.draw_card()
	if result is GDScriptFunctionState:
		yield(result,"completed")

