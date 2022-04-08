extends Node2D
class_name ExtraCardPanel

var blackout:Polygon2D
var pivot:Node2D

var extra_cards:Array = []

var v:float = 0
var length:float = 0

func _ready():
	blackout = $blackout
	if !blackout:
		print_debug("blackout not found")
	pivot = $extra_cards_pivot
	if !pivot:
		print("pivot not found")

func set_blackout_display(show:bool):
	blackout.visible = show

func get_all_cards()->Array:
	return pivot.get_children()

func add_cards(cards:Array):
	for card in cards:
		add_card(card)
	reset_cards_position()

# 添加卡片到额外面板区域
func add_card(card:Card):
	var ec = ExtraCard.new(card)
	GameManager.extra_card_panel.extra_cards.append(ec)
	ec.move_to_extra()

# 设置1张卡片的位置
func set_card_position(card:Card, index:int):
	card.position_tar_x = index % 4 * 120 - 180 +512
	card.position_tar_y = index / 4 * 120 + 52
	length = (index / 4 + 1) * 120
	
# 设置所有卡片的位置
func reset_cards_position():
	var index:int = 0
	for ec in extra_cards:
		ec.move_to_extra()
		set_card_position(ec.card, index)
		index += 1
	if length < 600:
		pivot.translate(Vector2(0,300 - length * 0.5))

# 把所有卡片送回原处
func move_back_all():
	for ec in extra_cards:
		if ec.card in get_all_cards():
			ec.move_back()
	extra_cards.clear()

func _process(delta):
	v *= 0.95
	if abs(v) <= 0.01:
		v = 0
	if pivot.position.y + length < 600 and v < 0:
		v = 0
	elif pivot.position.y  > 0 and v > 0:
		v = 0
	pivot.translate(Vector2(0,v))

func _input(event):
	if event.is_action("scroll_up"):
		v += 2
	elif event.is_action("scroll_down"):
		v -= 2

# 额外卡片
class ExtraCard:
	var card:Card
	var state:String
	func _init(_card:Card):
		card = _card
		state = card.get_state()
	func move_to_extra():
		GameManager.change_parent_keep_position(card, GameManager.extra_card_panel.pivot)
		card.tar_distance = 0.7
	func move_back():
		if state == "chara":
			GameManager.move_card_to_chara(card, self.grid_x,self.grid_y)
		elif state == "scene":
			GameManager.move_card_to_scene(card, self.grid_x,self.grid_y)
		elif state == "hand":
			GameManager.move_card_to_hand(card)
		elif state == "draw":
			GameManager.move_card_to_draw_pile(card)
		elif state == "discard":
			GameManager.move_card_to_discard_pile(card)
		else:
			print_debug("error: 检视的卡片状态错误%s" % state)

