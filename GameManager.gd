# GameManager全局脚本

extends Node

var table_grid: = preload("res://Scenes/table_grid.tscn")
var card_log_cabin = preload("res://Cards/card_log_cabin.tscn")

var resource_pivot:Node2D

var grid_pivot:Node2D
var scene_card_pivot:Node2D
var chara_card_pivot:Node2D

var inspect_area_pivot:Node2D

var hand_cards_pivot:Node2D
var draw_pile_pivot:Sprite
var discard_pile_pivot:Sprite

var day_num:int = 0

var fish:int = 0 setget set_fish
var wood:int = 0 setget set_wood
var sanity:int = 3 setget set_sanity
var health:int = 3 setget set_health

enum game_state {waiting, running}

func _ready():
	grid_pivot = get_node("/root/main/table_pivot/grid_pivot")
	if !grid_pivot:
		print_debug("error: grid_pivot not found")
	
	scene_card_pivot = get_node("/root/main/table_pivot/scene_card_pivot")
	if !scene_card_pivot:
		print_debug("error: scene_card_pivot not found")
		
	chara_card_pivot = get_node("/root/main/table_pivot/chara_card_pivot")
	if !scene_card_pivot:
		print_debug("error: chara_card_pivot not found")
		
	resource_pivot = get_node("/root/main/HUD/resource_pivot")
	if !resource_pivot:
		print_debug("error: resource_pivot not found")
		
	inspect_area_pivot = get_node("/root/main/inspect_area_pivot")
	if !inspect_area_pivot:
		print_debug("error: inspect_area_pivot not found")
		
	hand_cards_pivot = get_node("/root/main/hand_cards_pivot")
	if !hand_cards_pivot:
		print_debug("error: hand_cards_pivot not found")
		
	draw_pile_pivot=get_node("/root/main/draw_pile_pivot")
	if !draw_pile_pivot:
		print_debug("error: draw_pile_pivot not found")
	
	discard_pile_pivot=get_node("/root/main/discard_pile_pivot")
	if !draw_pile_pivot:
		print_debug("error: discard_pile_pivot not found")

func fish_max()->int:
	return 3
	
func wood_max()->int:
	return 3

func set_fish(num:int):
	fish = num
	if fish < 0:
		fish = 0
	elif fish > fish_max():
		fish = fish_max()
	
	resource_pivot.renew_fish()


func set_wood(num:int):
	wood = num
	if wood < 0:
		wood = 0
	elif wood > wood_max():
		wood = wood_max()
	
	resource_pivot.renew_wood()


func set_sanity(num:int)->void:
	sanity = num
	if sanity < 0:
		sanity = 0
	
	resource_pivot.renew_sanity()

func set_health(num:int)->void:
	health = num
	if health < 0:
		health = 0
	
	resource_pivot.renew_health()

# 获取坐标位置的网格
func get_grid_at(x:int,y:int)->TableGrid:
	for i in grid_pivot.get_children():
		if i.x == x and i.y == y:
			return i
	return null

# 创建单个网格
func create_grid(x:int,y:int)->void:
	var t = table_grid.instance()
	t.x = x
	t.y = y
	grid_pivot.add_child(t)
	t.transform = Transform2D(0, Vector2(x * 64 + 32, y * 64 + 32))
	t.set_land()

# 创建方形区域的桌子网格
func create_grid_rect(row:int, column:int)->void:
	for x in range(row):
		for y in range(column):
			create_grid(x, y)

# 创建卡片
func create_card(card_scene:PackedScene)->Card:
	var c = card_scene.instance() as Card
	c.position = Vector2(512,300)
	return c

# 把卡片移动到手卡
func move_card_to_hand(card_instance:Card)->void:
	if !card_instance:
		print_debug("error: card_instance = null")
		return
	print("移动卡片到手牌" + card_instance.to_string())
	change_parent_keep_position(card_instance, hand_cards_pivot)
	
	card_instance.tar_scale = 1.5
	hand_cards_pivot.reset_cards_position()
	
# 把卡片移动到抽牌堆
func move_card_to_draw_pile(card_instance:Card)->void:
	if !card_instance:
		print_debug("error: card_instance = null")
		return
	print("移动卡片到抽牌堆" + card_instance.to_string())
	change_parent_keep_position(card_instance, draw_pile_pivot)
	
	card_instance.position_tar_x = 0
	card_instance.position_tar_y = 0
	card_instance.tar_scale = 1

# 把卡片移动到弃牌堆
func move_card_to_discard_pile(card_instance:Card)->void:
	if !card_instance:
		print_debug("error: card_instance = null")
		return
	print("移动卡片到弃牌堆" + card_instance.to_string())
	change_parent_keep_position(card_instance, discard_pile_pivot)
	
	card_instance.position_tar_x = 0
	card_instance.position_tar_y = 0
	card_instance.tar_scale = 1

# 检视卡片
func move_card_to_inspect_area(card_instance:Card)->void:
	if !card_instance:
		print_debug("error: card_instance = null")
		return
	print("移动卡片到检视区" + card_instance.to_string())
	change_parent_keep_position(card_instance, inspect_area_pivot)
	
	card_instance.position_tar_x = 0
	card_instance.position_tar_y = 0
	card_instance.tar_scale = 4

# 放置卡片为场景
func move_card_to_scene(card_instance:Card, x:int, y:int)->void:
	if !card_instance:
		print_debug("error: card_instance = null")
		return
	if !get_grid_at(x, y):
		print_debug("error: 无法放置卡片为场景%s(%s,%s)，超出网格范围" % [card_instance, x, y])
		return
	print("放置卡片为场景%s(%s,%s)" % [card_instance, x, y])
	card_instance.grid_x = x
	card_instance.grid_y = y
	change_parent_keep_position(card_instance, scene_card_pivot)
	card_instance.position_tar_x = x * 64 + 32
	card_instance.position_tar_y = y * 64 + 32
	card_instance.tar_scale = 1

# 获取所有的场景卡
func get_scene_cards()->Array:
	return scene_card_pivot.get_children()


# 放置卡片为角色
func move_card_to_chara(card_instance:Card, x:int, y:int)->void:
	if !card_instance:
		print_debug("error: card_instance = null")
		return
	if !get_grid_at(x, y):
		print_debug("error: 无法放置卡片为角色%s(%s,%s)，超出网格范围" % [card_instance, x, y])
		return
	print("放置卡片为角色%s(%s,%s)" % [card_instance, x, y])
	card_instance.grid_x = x
	card_instance.grid_y = y
	change_parent_keep_position(card_instance, chara_card_pivot)
	card_instance.position_tar_x = x * 64 + 32
	card_instance.position_tar_y = y * 64 + 32
	card_instance.tar_scale = 1
	
# 获取所有的角色卡
func get_chara_cards()->Array:
	return chara_card_pivot.get_children()

# 置入节点并维持位置
func change_parent_keep_position(node:Node2D, new_parent:Node2D)->void:
	var p_global: = node.to_global(Vector2.ZERO)
	var parent: = node.get_parent() as Node2D
	if parent:
		parent.remove_child(node)
	new_parent.add_child(node)
	node.position = new_parent.to_local(p_global) 


# 获取所有的手卡
func get_hand_cards()->Array:
	return hand_cards_pivot.get_children()

# 获取所有抽牌堆卡片
func get_draw_pile_cards()->Array:
	return draw_pile_pivot.get_children()

# 获取所有弃牌堆卡片
func get_discard_pile_cards()->Array:
	return discard_pile_pivot.get_children()

# 获取检视区卡片
func get_inspect_area_card()->Card:
	return inspect_area_pivot.get_child(0) as Card

# 把卡片移动到剔除区
func move_card_to_eliminate_area(card_instance:Card)->void:
	pass

# 触发开始阶段
func trigger_start_phase()->void:
	day_num += 1
	print("第" + str(day_num) + "天开始阶段")
	return
	
# 触发结束阶段
func trigger_end_phase()->void:
	print("第" + str(day_num) + "天结束阶段")
	return

# 触发抽牌阶段
func trigger_draw_phase()->void:
	print("玩家抽牌阶段")
	return

# 计算最大手牌数量
func hand_cards_max()->int:
	return 3

# 触发弃牌阶段
func trigger_discard_phase()->void:
	print("玩家弃牌阶段")
	return

# 将抽牌堆洗牌
func shuffel_draw_pile()->void:
	print("抽牌堆洗牌")
	pass

# 设置手卡显示状态
func set_hand_cards_display(show:bool):
	hand_cards_pivot.flag_show = show
