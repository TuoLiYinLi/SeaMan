extends Sprite

var card_info:Label

var tar_x:float = 1215

func _ready():
	card_info = $card_info
	if !card_info:
		print_debug("card_info not found")

func _process(delta):
	translate((Vector2(tar_x, position.y) - position) * delta * 16)
	var c = GameManager.inspect_area_pivot.get_children()
	if !c.empty() and abs(c[0].position.x) < 64 and c[0].distance < 0.4:
		tar_x = 850
		card_info.text = c[0].info
	else:
		tar_x = 1215
	
