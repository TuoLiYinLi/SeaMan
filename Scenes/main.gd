# 主场景脚本

extends Node2D

var G := GameManager

var t=0
var c

func _ready():
	G.create_grid_rect(9,9)
	G.get_grid_at(1,2).set_sea()
	c = G.create_card(G.card_log_cabin)
	G.move_card_to_hand(c)
	c = G.create_card(G.card_log_cabin)
	G.move_card_to_hand(c)
	c = G.create_card(G.card_log_cabin)
	G.move_card_to_hand(c)
	c = G.create_card(G.card_log_cabin)
	G.move_card_to_scene(c,2,2)
	c = G.create_card(G.card_log_cabin)
	G.move_card_to_scene(c,2,7)
	c = G.create_card(G.card_log_cabin)
	G.set_prompt("")
	
	G.trigger_start_phase()

func _process(delta):
	
	control_view(delta)
	t += 1
	if(t == 500):
		G.set_prompt("测试")
		#G.inspect_card(c)
		pass
		#G.set_hand_cards_display(false)
	if(t == 1000):
		#G.finish_inspect_card()
		pass

# 控制视角
func control_view(delta):
	if Input.is_action_pressed("ui_left"):
		$table_pivot.transform = $table_pivot.transform.translated(Vector2(128 * delta,0))
	elif Input.is_action_pressed("ui_right"):
		$table_pivot.transform = $table_pivot.transform.translated(Vector2(- 128 * delta,0))
	if Input.is_action_pressed("ui_up"):
		$table_pivot.transform = $table_pivot.transform.translated(Vector2(0,128 * delta))
	elif Input.is_action_pressed("ui_down"):
		$table_pivot.transform = $table_pivot.transform.translated(Vector2(0,- 128 * delta))
	
