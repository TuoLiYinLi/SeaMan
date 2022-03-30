# 主场景脚本

extends Node2D

var t=0
var c

func _ready():
	GameManager.create_grid_rect(9,9)
	GameManager.get_grid_at(1,2).set_sea()
	c = GameManager.create_card(GameManager.card_log_cabin)
	GameManager.move_card_to_inspect_area(c)
	c = GameManager.create_card(GameManager.card_log_cabin)
	GameManager.move_card_to_hand(c)
	c = GameManager.create_card(GameManager.card_log_cabin)
	GameManager.move_card_to_hand(c)
	c = GameManager.create_card(GameManager.card_log_cabin)
	GameManager.move_card_to_hand(c)

func _process(delta):
	control_view(delta)
	t += 1
	if(t == 500):
		GameManager.set_hand_cards_display(false)
		GameManager.card_button.set_as_card_activate_button()
	

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
	
