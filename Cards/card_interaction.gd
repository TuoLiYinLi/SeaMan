extends TextureButton

var card:Card

func _ready():
	card = get_parent() as Card
	if !card:
		print_debug("error: card not found")

func _pressed():
	print("pressed")
	inspect_this_card()
	

# 进行检视
func inspect_this_card():
	if true:
		GameManager.inspect_card(card)

func _process(delta):
	if is_hovered():
		card.z_index = 1
	else:
		card.z_index = 0
