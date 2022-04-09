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
	
	G.move_card_to_draw_pile(G.create_card(G.card_riprap))
	G.move_card_to_draw_pile(G.create_card(G.card_woods_growth))
	G.move_card_to_draw_pile(G.create_card(G.card_slime_multiplication))
	G.move_card_to_draw_pile(G.create_card(G.card_seal))
	G.move_card_to_draw_pile(G.create_card(G.card_crow))
	G.move_card_to_draw_pile(G.create_card(G.card_reading))
	G.move_card_to_draw_pile(G.create_card(G.card_desperate_fight))
	G.move_card_to_draw_pile(G.create_card(G.card_nurture))
	G.move_card_to_draw_pile(G.create_card(G.card_tide))
	G.move_card_to_draw_pile(G.create_card(G.card_tower))
	G.move_card_to_draw_pile(G.create_card(G.card_building_rectification))
	G.move_card_to_draw_pile(G.create_card(G.card_construction_planning))
	G.move_card_to_draw_pile(G.create_card(G.card_fresh_fish))
	G.move_card_to_draw_pile(G.create_card(G.card_guard))
	G.move_card_to_draw_pile(G.create_card(G.card_wanted_poster))
	G.move_card_to_draw_pile(G.create_card(G.card_woodcutter))
	G.move_card_to_draw_pile(G.create_card(G.card_little_ents))
	G.move_card_to_draw_pile(G.create_card(G.card_kipper_wigwam))
	G.move_card_to_draw_pile(G.create_card(G.card_muddy_path))
	G.move_card_to_draw_pile(G.create_card(G.card_logging_camp))
	G.move_card_to_draw_pile(G.create_card(G.card_working_table))
	G.move_card_to_draw_pile(G.create_card(G.card_slime))
	G.move_card_to_draw_pile(G.create_card(G.card_fresh_fish))
	G.move_card_to_draw_pile(G.create_card(G.card_woods))
	G.move_card_to_draw_pile(G.create_card(G.card_woods))
	G.move_card_to_draw_pile(G.create_card(G.card_pit))
	G.move_card_to_draw_pile(G.create_card(G.card_woods))
	G.move_card_to_draw_pile(G.create_card(G.card_woods))
	G.move_card_to_draw_pile(G.create_card(G.card_log_cabin))
	G.move_card_to_draw_pile(G.create_card(G.card_fishing_gear))
	G.move_card_to_draw_pile(G.create_card(G.card_fishing_gear))
	
	yield(get_tree().create_timer(1),"timeout")
	
	G.fish=3
	G.wood=3
	
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
	
