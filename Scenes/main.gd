# 主场景脚本

extends Node2D

var G := GameManager

var t = 0
var c

var a:Array

func _ready():
	
	randomize()
	
	G.create_grid_rect(9,9)
	
	c = G.create_card(G.card_log_cabin)
	G.move_card_to_scene(c,4,4)
	
	G.move_card_to_draw_pile(G.create_card(G.card_woodcutter))
	G.move_card_to_draw_pile(G.create_card(G.card_little_ents))
	G.move_card_to_draw_pile(G.create_card(G.card_kipper_wigwam))
	G.move_card_to_draw_pile(G.create_card(G.card_logging_camp))
	G.move_card_to_draw_pile(G.create_card(G.card_working_table))
	G.move_card_to_draw_pile(G.create_card(G.card_slime))
	G.move_card_to_draw_pile(G.create_card(G.card_fresh_fish))
	G.move_card_to_draw_pile(G.create_card(G.card_fresh_fish))
	G.move_card_to_draw_pile(G.create_card(G.card_woods))
	G.move_card_to_draw_pile(G.create_card(G.card_woods))
	G.move_card_to_draw_pile(G.create_card(G.card_woods))
	G.move_card_to_draw_pile(G.create_card(G.card_woods))
	G.move_card_to_draw_pile(G.create_card(G.card_log_cabin))
	G.move_card_to_draw_pile(G.create_card(G.card_fishing_gear))
	G.move_card_to_draw_pile(G.create_card(G.card_fishing_gear))
	
	yield(get_tree().create_timer(1),"timeout")
	
	G.start_new_game()
	

func _process(delta):
	control_view(delta)

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
	
