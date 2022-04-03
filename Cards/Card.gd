extends Node2D
class_name Card

export (float) var multiplier:float = 100

var position_tar_x:float
var position_tar_y:float
var tar_scale:float = 1

var grid_x:int = -1
var grid_y:int = -1

var info:String = """默认卡片信息"""

var distance = 1
var tar_distance = 1
var k = 400

var card_sprite:Sprite
var card_border:Sprite

func _ready():
	card_sprite = get_node("card_sprite") as Sprite
	if(!card_sprite):
		print_debug("error: card_sprite not found")
		
	card_border = get_node("card_sprite/card_border") as Sprite
	if(!card_border):
		print_debug("error: card_border not found")
	

# 开始阶段时
func on_start_phase():
	return
# 结束阶段时
func on_end_phase():
	return
# 当被从场上摧毁时
func on_destroy():
	pass
# 当被从手牌丢弃时
func on_discard():
	pass
# 当抽到这张卡片时
func on_draw():
	return true
# 使用手中的这张卡片
func use():
	pass
# 激活场上的这张卡片
func activate():
	pass

# 更新补间动画效果
func tween_animation(delta):
	# 更新位置
	var d = Vector2(position_tar_x, position_tar_y) - position
	var d_length = d.length()
	if d_length > 1:
		translate(d.normalized() * tween_d(d_length) * delta * multiplier)
	
	#更新缩放
	distance += tween_d((tar_distance - distance) * k) / k * delta * multiplier
	var f_scale:float = 1.0 / distance
	
	scale = Vector2(f_scale,f_scale)
	
# 距离速度函数
func tween_d(_distance:float)->float:
	if(_distance > 0): 
		return log(_distance + 1)
	if(_distance < 0):
		return -log(- _distance + 1)
	else:
		return 0.0

func _physics_process(delta):
	tween_animation(delta)

# 判断卡片当前状态
func get_state()->String:
	var parent = get_parent()
	print(parent)
	if parent == GameManager.chara_card_pivot:
		return "chara"
	elif parent == GameManager.scene_card_pivot:
		return "scene"
	elif parent == GameManager.hand_cards_pivot:
		return "hand"
	elif parent == GameManager.draw_pile_pivot:
		return "draw"
	elif parent == GameManager.discard_pile_pivot:
		return "discard"
	elif parent == GameManager.inspect_area_pivot:
		return "inspect"
	else:
		print_debug("error: 卡片父级发生错误 "+str(parent))
		return "error"
