extends Card
class_name CardNurture


func _ready():
	info = """修养
	\u25cf当被从手牌丢弃时，获得相当于手牌数量（除此卡）的健康
	"""


# 当被从手牌丢弃时
func on_discard():
	GameManager.health += GameManager.hand_cards_all().size()
