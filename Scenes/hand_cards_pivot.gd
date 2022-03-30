# 手卡锚点脚本

extends Node2D

export(float) var area_width:float = 400 #卡片存在的宽度范围
export(float) var gap_width:float = 72 #卡片间的距离
export(float) var y_show:float = 550
export(float) var y_hide:float = 632

var flag_show:bool

# 设置1张卡片的位置
func set_card_position(card:Card, card_index:int, total_num:int)->void:
	if total_num <= 0:
		return
	elif total_num <= 1:
		card.position_tar_x = 0
	else:
		var step_distance:float = area_width / (total_num - 1)
		if(step_distance > gap_width):
			step_distance = gap_width
		
		card.position_tar_x = step_distance *((1 + total_num) * -0.5 + card_index)
	
	card.position_tar_y = 0

# 重置所有手卡的位置
func reset_cards_position():
	var total_num:int = get_children().size()
	var current_num:int = 1
	for card in get_children():
		set_card_position(card, current_num, total_num)
		current_num += 1

func _ready():
	flag_show = true

func _process(delta):
	if flag_show:
		translate((Vector2(position.x, y_show)-position) * delta * 4)
	else:
		translate((Vector2(position.x, y_hide)-position) * delta * 4)
