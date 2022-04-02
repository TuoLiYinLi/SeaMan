extends Card
class_name CardFreshFish


func _ready():
	info = """鲜鱼
	\u25cf当抽到时，自动使用，获得1点鱼，之后抽一张卡片
	【鱼】"""

# 当抽到这张卡片时
func on_draw():
	var result = use()
	if result is GDScriptFunctionState:
		yield(result,"completed")


# 使用手中的这张卡片
func use():
	GameManager.set_inspect_permission(false)
	# yield(get_tree().create_timer(1.5),"timeout")
	GameManager.move_card_to_discard_pile(self)
	
	GameManager.fish += 1
	
	GameManager.set_inspect_permission(true)
	var result = GameManager.draw_card()
	if result is GDScriptFunctionState:
		yield(result,"completed")
