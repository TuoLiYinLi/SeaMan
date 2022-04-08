# GameManager全局脚本

extends Node

var table_grid: = preload("res://Scenes/table_grid.tscn")	#网格
var card_log_cabin: = preload("res://Cards/card_log_cabin.tscn")	# 木屋
var card_woods: = preload("res://Cards/card_woods.tscn")	# 林地
var card_slime: = preload("res://Cards/card_slime.tscn") 	# 史莱姆
var card_fresh_fish: = preload("res://Cards/card_fresh_fish.tscn")	# 鲜鱼
var card_fishing_gear: = preload("res://Cards/card_fishing_gear.tscn")	# 渔网
var card_logging_camp: = preload("res://Cards/card_logging_camp.tscn")	# 伐木场
var card_working_table: = preload("res://Cards/card_working_table.tscn")	# 工作台
var card_kipper_wigwam: = preload("res://Cards/card_kipper_wigwam.tscn")	# 腌鱼棚
var card_little_ents: = preload("res://Cards/card_little_ents.tscn")	# 小树精
var card_woodcutter: = preload("res://Cards/card_woodcutter.tscn")	# 樵夫
var card_guard: = preload("res://Cards/card_guard.tscn")	# 守卫
var card_wanted_poster: = preload("res://Cards/card_wanted_poster.tscn")	# 通缉令
var card_construction_planning: = preload("res://Cards/card_construction_planning.tscn")	# 通缉令
var card_building_rectification: = preload("res://Cards/card_building_rectification.tscn")	# 通缉令
var card_tower: = preload("res://Cards/card_tower.tscn")	# 通缉令

var resource_pivot:ResourcePivot	#资源面板锚点引用

var grid_pivot:Node2D	# 网格锚点引用
var scene_card_pivot:Node2D # 场景卡锚点引用
var chara_card_pivot:Node2D # 角色卡锚点引用

var inspect_area_pivot:InspectCardPivot	# 检视区锚点引用

var hand_cards_pivot:HandCardsPivot	# 手卡锚点引用
var draw_pile_pivot:Node2D	# 抽牌堆锚点引用
var discard_pile_pivot:Node2D	#弃牌堆锚点引用 
var eliminate_area_pivot:Node2D	#剔除区锚点引用 

var prompt:Label	# 提示语的引用

var bell:Bell	# 对铃铛的引用 
var extra_card_panel:ExtraCardPanel # 对额外卡片面板的引用
var void_area:TextureButton	#背景空区域按钮的引用

# 结束控制阶段信号
signal control_finished
# 按下的网格，传递它的坐标
signal table_grid_pressed(grid_x, grid_y)
# 按下的卡片,传递它的引用
signal card_pressed(card)
# 玩家点击鼠标
signal player_click

# 枚举状态标志
enum State{inspect = 0, select_grid = 1, select_card = 2, lock = 3,select_specific_card = 4}
# 状态标志
var flag_state:int = State.lock

# 第几天
var day_num:int = 0
# 第几轮
var period_num:int = 1
# 鱼点数
var fish:int = 0
# 木头点数
var wood:int = 0
# 理智点数
var sanity:int = 3
# 健康点数
var health:int = 3

func _ready():

	# 获取引用

	grid_pivot = get_node("/root/main/table_pivot/grid_pivot")
	if !grid_pivot:
		print_debug("error: grid_pivot not found")
	
	scene_card_pivot = get_node("/root/main/table_pivot/scene_card_pivot")
	if !scene_card_pivot:
		print_debug("error: scene_card_pivot not found")
		
	chara_card_pivot = get_node("/root/main/table_pivot/chara_card_pivot")
	if !chara_card_pivot:
		print_debug("error: chara_card_pivot not found")
		
	resource_pivot = get_node("/root/main/HUD/resource_pivot")
	if !resource_pivot:
		print_debug("error: resource_pivot not found")
		
	inspect_area_pivot = get_node("/root/main/HUD/inspect_area_pivot")
	if !inspect_area_pivot:
		print_debug("error: inspect_area_pivot not found")
		
	hand_cards_pivot = get_node("/root/main/HUD/hand_cards_pivot")
	if !hand_cards_pivot:
		print_debug("error: hand_cards_pivot not found")
		
	draw_pile_pivot = get_node("/root/main/HUD/draw_pile_pivot")
	if !draw_pile_pivot:
		print_debug("error: draw_pile_pivot not found")
	
	discard_pile_pivot = get_node("/root/main/HUD/discard_pile_pivot")
	if !discard_pile_pivot:
		print_debug("error: discard_pile_pivot not found")
		
	eliminate_area_pivot = get_node("/root/main/HUD/eliminate_area_pivot")
	if !discard_pile_pivot:
		print_debug("error: eliminate_area_pivot not found")
	
	prompt = get_node("/root/main/HUD/prompt")
	if !prompt:
		print_debug("error: prompt not found")
		
	bell = get_node("/root/main/HUD/bell")
	if !bell:
		print_debug("error: bell not found")
		
	void_area = get_node("/root/main/void_area")
	if !void_area:
		print_debug("error: void_area not found")
		
	extra_card_panel = get_node("/root/main/HUD/extra_card_panel")
	if !extra_card_panel:
		print_debug("error: extra_card_panel not found")


# 处理输入
func _input(event):
	if event.is_action_released("mouse_left"):
		emit_signal("player_click")

# 计算鱼储量
func fish_max()->int:
	return 3 * count_in_scene_cards(CardLogCabin) + 2 *count_in_scene_cards(CardKipperWigwam)

# 计算木头储量
func wood_max()->int:
	return 3 * count_in_scene_cards(CardLogCabin) + count_in_scene_cards(CardLoggingCamp)

# 检查所有的资源点数
func check_resources():
	check_fish()
	check_wood()
	check_health()
	check_sanity()

# 检查鱼点数
func check_fish():
	if fish < 0:
		fish = 0
	elif fish > fish_max():
		fish = fish_max()

# 检查木头点数
func check_wood():
	if wood < 0:
		wood = 0
	elif wood > wood_max():
		wood = wood_max()

# 检查理智点数
func check_sanity()->void:
	if sanity < 0:
		sanity = 0

# 检查健康点数
func check_health()->void:
	if health < 0:
		health = 0

# 开始一局新的游戏
func start_new_game()->void:
	print("开始新游戏")
	set_state_lock()
	
	trigger_start_phase()
	return

# 清理场景，结束当前游戏
func finish_game()->void:
	print("结束游戏")
	return

# 获取坐标位置的网格
func grid_at(x:int, y:int)->TableGrid:
	for i in grid_pivot.get_children():
		if i.x == x and i.y == y:
			return i
	return null

# 获取所有的网格
func grids_all()->Array:
	return grid_pivot.get_children()

# 获取目标范围内的网格
func grids_in_distance(x:int, y:int, r:int)->Array:
	var out_array=[]
	for g in grids_all():
		if distance_between(x, y, g.x, g.y) <= r:
			out_array.append(g)
	return out_array

# 将所有网格按照距离排序
func grids_sort_distance_to(x:int, y:int)->Array:
	var grids:Array = grids_all()
	var gds: = GridDistanceSorter.new(x,y)
	grids.sort_custom(gds,"compare")
	return grids

# 用于自定义排序的类
class GridDistanceSorter:
	var tar_x:int
	var tar_y:int
	func _init(x:int,y:int):
		tar_x = x
		tar_y = y
	func compare(g1:TableGrid, g2:TableGrid)->bool:
		var d1 = GameManager.distance_between(g1.x, g1.y, tar_x, tar_y)
		var d2 = GameManager.distance_between(g2.x, g2.y, tar_x, tar_y)
		return d2 > d1 

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
func create_card(card_scene:PackedScene, x:float = 512, y:float = 300)->Card:
	var c = card_scene.instance() as Card
	c.position = Vector2(x,y)
	return c

# 把卡片移动到手卡
func move_card_to_hand(card_instance:Card)->void:
	if !card_instance:
		print_debug("error: card_instance = null")
		return
	print("移动卡片到手牌" + card_instance.to_string())
	change_parent_keep_position(card_instance, hand_cards_pivot)
	
	card_instance.tar_distance = 0.7
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
	card_instance.tar_distance = 1

# 破坏卡片（触发破坏）
func destroy_card(card:Card):
	move_card_to_discard_pile(card)
	var result = card.on_destroy()
	if result is GDScriptFunctionState:
		yield(result,"completed")

# 把卡片移动到弃牌堆
func move_card_to_discard_pile(card_instance:Card)->void:
	if !card_instance:
		print_debug("error: card_instance = null")
		return
	print("移动卡片到弃牌堆" + card_instance.to_string())
	change_parent_keep_position(card_instance, discard_pile_pivot)
	
	card_instance.position_tar_x = 0
	card_instance.position_tar_y = 0
	card_instance.tar_distance = 1

# 计算范围距离
func distance_between(x1:int, y1:int, x2:int, y2:int)->int:
	return (abs(x1 - x2) + abs(y1 - y2)) as int

# 场景卡按照距离排序
func scene_cards_sort_distance_to(x:int, y:int)->Array:
	var cards:Array = scene_cards_all()
	var cds: = CardDistanceSorter.new(x,y)
	cards.sort_custom(cds,"compare")
	return cards

# 角色卡按照距离排序
func chara_cards_sort_distance_to(x:int, y:int)->Array:
	var cards:Array = chara_cards_all()
	var cds: = CardDistanceSorter.new(x,y)
	cards.sort_custom(cds,"compare")
	return cards
	
# 用于自定义排序的类
class CardDistanceSorter:
	var tar_x:int
	var tar_y:int
	func _init(x:int,y:int):
		tar_x = x
		tar_y = y
	func compare(c1:Card, c2:Card)->bool:
		var d1 = GameManager.distance_between(c1.grid_x, c1.grid_y, tar_x, tar_y)
		var d2 = GameManager.distance_between(c2.grid_x, c2.grid_y, tar_x, tar_y)
		return d2 > d1 

# 检视卡片
func move_card_to_inspect_area(card_instance:Card)->void:
	if !card_instance:
		print_debug("error: card_instance = null")
		return
	print("移动卡片到检视区" + card_instance.to_string())
	change_parent_keep_position(card_instance, inspect_area_pivot)
	
	card_instance.position_tar_x = 0
	card_instance.position_tar_y = 0
	card_instance.tar_distance = 0.25

# 放置卡片为场景
func move_card_to_scene(card_instance:Card, x:int, y:int)->void:
	if !card_instance:
		print_debug("error: card_instance = null")
		return
	if !grid_at(x, y):
		print_debug("error: 无法放置卡片为场景%s(%s,%s)，超出网格范围" % [card_instance, x, y])
		return
	print("放置卡片为场景%s(%s,%s)" % [card_instance, x, y])
	card_instance.grid_x = x
	card_instance.grid_y = y
	change_parent_keep_position(card_instance, scene_card_pivot)
	card_instance.position_tar_x = x * 64 + 32
	card_instance.position_tar_y = y * 64 + 32
	card_instance.tar_distance = 1

# 获取所有的场景卡
func scene_cards_all()->Array:
	var cards: = scene_card_pivot.get_children()
	var c := inspect_area_card()
	if c and inspect_area_pivot.card_ori_state == "scene":
		cards.append(c)
	return cards

# 获取某一位置的场景卡
func scene_card_at(x:int, y:int)->Card:
	for c in scene_cards_all():
		if c.grid_x == x and c.grid_y == y:
			return c
	return null

# 放置卡片为角色
func move_card_to_chara(card_instance:Card, x:int, y:int)->void:
	if !card_instance:
		print_debug("error: card_instance = null")
		return
	if !grid_at(x, y):
		print_debug("error: 无法放置卡片为角色%s(%s,%s)，超出网格范围" % [card_instance, x, y])
		return
	print("放置卡片为角色%s(%s,%s)" % [card_instance, x, y])
	card_instance.grid_x = x
	card_instance.grid_y = y
	change_parent_keep_position(card_instance, chara_card_pivot)
	card_instance.position_tar_x = x * 64 + 32
	card_instance.position_tar_y = y * 64 + 32
	card_instance.tar_distance = 1

# 获取所有的角色卡
func chara_cards_all()->Array:
	var cards: = chara_card_pivot.get_children()
	var c := inspect_area_card()
	if c and inspect_area_pivot.card_ori_state == "chara":
		cards.append(c)
	return cards
	
# 获取某一位置的角色卡
func chara_card_at(x:int, y:int)->Card:
	for c in chara_cards_all():
		if c.grid_x == x and c.grid_y == y:
			return c
	return null

# 置入节点并维持位置
func change_parent_keep_position(node:Node2D, new_parent:Node2D)->void:
	var p_global: = node.position
	var parent: = node.get_parent() as Node2D
	if parent:
		p_global = node.to_global(Vector2.ZERO)
		parent.remove_child(node)
		if parent == hand_cards_pivot:
			hand_cards_pivot.reset_cards_position()
	new_parent.add_child(node)
	node.position = new_parent.to_local(p_global) 
	
# 获取所有卡片
func cards_all()->Array:
	var cards: = hand_cards_pivot.get_children()
	cards.append_array(chara_card_pivot.get_children())
	cards.append_array(scene_card_pivot.get_children())
	cards.append_array(draw_pile_pivot.get_children())
	cards.append_array(discard_pile_pivot.get_children())
	cards.append_array(eliminate_area_pivot.get_children())
	var c = inspect_area_card()
	if c:
		cards.append(c)
	return cards
	

# 获取所有的手卡
func hand_cards_all()->Array:
	var cards: = hand_cards_pivot.get_children()
	var c := inspect_area_card()
	if c and inspect_area_pivot.card_ori_state == "hand":
		cards.append(c)
	return cards

# 获取所有抽牌堆卡片
func draw_pile_cards_all()->Array:
	var cards: = draw_pile_pivot.get_children()
	var c := inspect_area_card()
	if c and inspect_area_pivot.card_ori_state == "draw":
		cards.append(c)
	return cards

# 获取所有弃牌堆卡片
func discard_pile_cards_all()->Array:
	var cards: = discard_pile_pivot.get_children()
	var c := inspect_area_card()
	if c and inspect_area_pivot.card_ori_state == "discard":
		cards.append(c)
	return cards

# 获取检视区卡片
func inspect_area_card()->Card:
	if !inspect_area_pivot.get_children().empty():
		return inspect_area_pivot.get_child(0) as Card
	return null

# 把卡片移动到剔除区
func move_card_to_eliminate_area(card_instance:Card)->void:
	if !card_instance:
		print_debug("error: card_instance = null")
		return
	print("移动卡片到剔除区" + card_instance.to_string())
	change_parent_keep_position(card_instance, eliminate_area_pivot)
	
	card_instance.position_tar_x = 0
	card_instance.position_tar_y = 0
	card_instance.tar_distance = 1

# 触发开始阶段
func trigger_start_phase()->void:
	day_num += 1
	print("第" + str(day_num) + "天开始阶段")
	for c in chara_cards_all():
		var result = c.on_start_phase()
		if result is GDScriptFunctionState:
			yield(result,"completed")
	for c in scene_cards_all():
		var result = c.on_start_phase()
		if result is GDScriptFunctionState:
			yield(result,"completed")
	print("开始阶段完成")
	trigger_draw_phase()
	
# 触发结束阶段
func trigger_end_phase()->void:
	print("第" + str(day_num) + "天结束阶段")
	finish_inspect_card()
	for c in chara_cards_all():
		var result = c.on_end_phase()
		if result is GDScriptFunctionState:
			yield(result,"completed")
	for c in scene_cards_all():
		var result = c.on_end_phase()
		if result is GDScriptFunctionState:
			yield(result,"completed")
	
	print("结束阶段完成")
	trigger_discard_phase()

# 触发抽牌阶段
func trigger_draw_phase()->void:
	print("玩家抽牌阶段")
	var result = draw_card()
	if result is GDScriptFunctionState:
		yield(result,"completed")
	print("抽卡阶段完成")
	trigger_control_phase()

# 抽一张卡片
func draw_card():
	print("准备抽一张卡片")
	var cards = draw_pile_cards_all()
	if !cards.empty():
		var card:Card = cards[0]
		print("抽到了%s" % card)
		move_card_to_hand(card)
		inspect_card(card)
		set_prompt("请确认")
		yield(self,"player_click")
		set_prompt("")
		move_card_to_hand(card)
		var result = card.on_draw()
		if result is GDScriptFunctionState:
			yield(result,"completed")
	else:
		print("没有可以抽的牌")
	print("抽牌结束")

# 计算最大手牌数量
func hand_cards_max()->int:
	return 3

# 触发玩家控制阶段
func trigger_control_phase()->void:
	print("玩家控制阶段")
	set_state_inspect()
	yield(GameManager,"control_finished")
	print("控制阶段结束")
	set_state_lock()
	yield(get_tree().create_timer(0.2),"timeout")
	trigger_end_phase()
	
# 触发弃牌阶段
func trigger_discard_phase()->void:
	print("玩家弃牌阶段")
	
	while hand_cards_all().size() > hand_cards_max():
		set_prompt("丢弃一张手牌")
		extra_card_panel.set_blackout_display(true)
		set_state_select_specific_cards(hand_cards_all())
		var result = yield(GameManager,"card_pressed")
		move_card_to_discard_pile(result)
		set_prompt("")
		extra_card_panel.set_blackout_display(false)
		set_state_lock()
		
	print("弃牌阶段完成")
	trigger_start_phase()

func set_state_select_specific_cards(cards:Array):
	set_state_lock()
	flag_state = State.select_specific_card
	extra_card_panel.add_cards(cards)
	for card in cards:
		card.get_node("card_interaction").disabled = false
		card.get_node("card_interaction").rect_scale = Vector2(1, 1)

# 将抽牌堆洗牌
func shuffel_draw_pile()->void:
	print("抽牌堆洗牌")

# 设置手卡显示状态(上下运动)
func set_hand_cards_display(show:bool)->void:
	hand_cards_pivot.flag_show = show

# 设置为检视卡片状态
func set_state_inspect()->void:
	extra_card_panel.move_back_all()
	set_hand_cards_display(true)
	flag_state = State.inspect
	# 回合结束
	bell.can_finish_control = true
	# 检视
	void_area.disabled = false
	# 手牌
	var cards = hand_cards_all()
	for card in cards:
		card.get_node("card_interaction").disabled = false
		card.get_node("card_interaction").rect_scale = Vector2(1, 1)
	# 场上卡片
	cards = scene_cards_all()
	cards.append_array(chara_cards_all())
	for card in cards:
		card.get_node("card_interaction").disabled = false
		card.get_node("card_interaction").rect_scale = Vector2(1, 1)
	# 网格
	for grid in grid_pivot.get_children():
		grid.get_node("grid_button").disabled = true
		grid.get_node("grid_button").rect_scale = Vector2(0, 0)
	

# 设置为选择网格状态
func set_state_select_grid()->void:
	extra_card_panel.move_back_all()
	set_hand_cards_display(false)
	flag_state = State.select_grid
	# 回合结束
	bell.can_finish_control = false
	# 检视
	void_area.disabled = true
	# 手牌
	var cards = hand_cards_all()
	for card in cards:
		card.get_node("card_interaction").disabled = true
		card.get_node("card_interaction").rect_scale = Vector2(0, 0)
	# 场上卡片
	cards = scene_cards_all()
	cards.append_array(chara_cards_all())
	for card in cards:
		card.get_node("card_interaction").disabled = true
		card.get_node("card_interaction").rect_scale = Vector2(0, 0)
	# 网格
	for grid in grid_pivot.get_children():
		grid.get_node("grid_button").disabled = false
		grid.get_node("grid_button").rect_scale = Vector2(1, 1)


# 设置为选择卡片状态
func set_state_select_card()->void:
	extra_card_panel.move_back_all()
	set_hand_cards_display(false)
	flag_state = State.select_card
	# 回合结束
	bell.can_finish_control = false
	# 检视
	void_area.disabled = true
	# 手牌
	var cards = hand_cards_all()
	for card in cards:
		card.get_node("card_interaction").disabled = true
		card.get_node("card_interaction").rect_scale = Vector2(0, 0)
	# 场上卡片
	cards = scene_cards_all()
	cards.append_array(chara_cards_all())
	for card in cards:
		card.get_node("card_interaction").disabled = false
		card.get_node("card_interaction").rect_scale = Vector2(1, 1)
	# 网格
	for grid in grid_pivot.get_children():
		grid.get_node("grid_button").disabled = true
		grid.get_node("grid_button").rect_scale = Vector2(0, 0)


# 设置为锁定状态
func set_state_lock()->void:
	extra_card_panel.move_back_all()
	set_hand_cards_display(false)
	flag_state = State.lock
	# 回合结束
	bell.can_finish_control = false
	# 检视
	void_area.disabled = true
	# 手牌
	var cards = cards_all()
	for card in cards:
		card.get_node("card_interaction").disabled = true
		card.get_node("card_interaction").rect_scale = Vector2(0, 0)
	
	# 网格
	for grid in grid_pivot.get_children():
		grid.get_node("grid_button").disabled = true
		grid.get_node("grid_button").rect_scale = Vector2(0, 0)

# 拿起卡片进行检视
func inspect_card(card_instance:Card)->void:
	print("检视卡片%s" % card_instance)
	var card_state = card_instance.get_state()
	if card_state == "inspect":
		print("不可检视正在检视的卡片")
		return
	finish_inspect_card()
	move_card_to_inspect_area(card_instance)
	inspect_area_pivot.card_ori_state = card_state

# 结束检视卡片
func finish_inspect_card()->void:
	var c:Card = inspect_area_card()
	if !c:
		print("停止检视卡片，没有卡片")
		return
	else:
		print("停止检视卡片")
		if inspect_area_pivot.card_ori_state == "chara":
			move_card_to_chara(c,c.grid_x,c.grid_y)
		elif inspect_area_pivot.card_ori_state == "scene":
			move_card_to_scene(c,c.grid_x,c.grid_y)
		elif inspect_area_pivot.card_ori_state == "hand":
			move_card_to_hand(c)
		elif inspect_area_pivot.card_ori_state == "draw":
			move_card_to_draw_pile(c)
		elif inspect_area_pivot.card_ori_state == "discard":
			move_card_to_discard_pile(c)
		else:
			print_debug("error: 检视的卡片状态错误%s" % inspect_area_pivot.card_ori_state)

# 设置提示语
func set_prompt(msg:String,color:Color = Color.white)->void:
	# print("提示语:%s" % msg)
	prompt.text = msg
	prompt.modulate = color

# 从一个卡片集合中筛选符合条件的卡片
func filter_cards(cards:Array, filter:FuncRef)->Array:
	var out_array:Array = []
	for card in cards:
		if filter.call_func(card):
			out_array.append(card)
	return out_array

# 从角色卡中数出某种卡片的数量
func count_in_chara_cards(card_type)->int:
	var count:int = 0
	for i in chara_cards_all():
		if i is card_type:
			count += 1
	return count

# 从场景卡中数出某种卡片的数量
func count_in_scene_cards(card_type)->int:
	var count:int = 0
	for i in scene_cards_all():
		if i is card_type:
			count += 1
	return count

# 检查卡片中是否包含标签
func check_card_tag(card:Card, tag:String):
	return ("【%s】" % tag) in card.info

# 目标范围内的场景卡
func scene_cards_in_distance(x:int, y:int, r:int)->Array:
	var cards := []
	for c in scene_cards_all():
		if distance_between(c.grid_x,c.grid_y,x,y) <= r:
			cards.append(c)
	return cards

# 目标范围内的角色卡
func chara_cards_in_distance(x:int, y:int, r:int)->Array:
	var cards := []
	for c in chara_cards_all():
		if distance_between(c.grid_x,c.grid_y,x,y) <= r:
			cards.append(c)
	return cards

# 检查能否在某个位置建造
func check_can_build_at(x:int, y:int)->bool:
	if scene_card_at(x,y):
		return false
	for card in GameManager.scene_cards_in_distance(x, y, 1):
		if GameManager.check_card_tag(card, "建筑"):
			return true
	return false

func highlight_card(card:Card):
	card.card_border.visible = true

func highlight_grid(grid:TableGrid):
		grid.set_pattern_color(Color.green)
		grid.set_pattern_index(true)

func reset_highlight_card():
	var cards: = cards_all()
	for c in cards:
		var card:Card = c
		card.card_border.visible = false


func reset_highlight_grid():
	var grids: = grids_all()
	for g in grids:
		var grid:TableGrid = g
		grid.set_pattern_color(Color.white)
		grid.set_pattern_index(false)
		
