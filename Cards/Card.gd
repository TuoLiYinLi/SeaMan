extends Node2D
class_name Card

export (float) var multiplier:float = 4

var position_tar_x:float
var position_tar_y:float
var tar_scale:float = 1

var grid_x:int = -1
var grid_y:int = -1

var card_sprite:Sprite

func _ready():
	card_sprite = get_node("card_sprite") as Sprite
	if(!card_sprite):
		print_debug("error: card_sprite not found")

# 开始阶段时
func on_start_phase()->void:
	pass
	
# 结束阶段时
func on_end_phase()->void:
	pass

# 当被从场上摧毁时
func on_destroy()->void:
	pass

# 当被从手牌丢弃时
func on_discard()->void:
	pass

# 当抽到这张卡片时
func on_draw()->void:
	pass
	
# 检查能否使用
func use_condition()->bool:
	return true
	
# 使用手中的这张卡片
func use()->void:
	pass

# 检查能否激活
func activate_condition()->bool:
	return true

# 激活场上的这张卡片
func activate()->void:
	pass

# 更新补间动画效果
func tween_animation(delta):
	# 更新位置
	var d = Vector2(position_tar_x, position_tar_y) - position
	translate(d.normalized() * tween_d(d.length()) * delta * multiplier)
	
	#更新缩放
	d = Vector2(tween_d(tar_scale - scale.x), tween_d(tar_scale - scale.y))
	scale += d * delta * multiplier * 0.0675

# 距离速度函数
func tween_d(distance:float)->float:
	if(distance > 0): 
		return log(distance + 1)
	if(distance < 0):
		return -log(- distance + 1)
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
