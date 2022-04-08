extends Node2D

var card_bg:AnimatedSprite
var eyeball:Sprite
var pupil:Sprite


func _ready():
	card_bg = $card_bg
	if !card_bg:
		print_debug("card_bg not found")
		
	
	eyeball = $eyeball
	if !eyeball:
		print_debug("eyeball not found")
		
	
	pupil = $pupil
	if !pupil:
		print_debug("pupil not found")
		
	yield(get_tree().create_timer(randf()*10.0 + 5.0),"timeout")
	wink()

func _on_card_bg_animation_finished():
	card_bg.playing = false
	yield(get_tree().create_timer(randf()*10.0 + 5.0),"timeout")
	wink()

func wink():
	if !card_bg.playing:
		card_bg.playing = true

func _input(event):
	if event is InputEventMouseMotion:
		#print("Mouse Motion at: %s" % event.position)
		pupil.position = (event.position - position)*0.02
		if pupil.position.length() > 6:
			pupil.position = pupil.position.normalized() * 6
		
		
		eyeball.position = (event.position - position)*0.008
		if eyeball.position.length() > 4:
			eyeball.position = eyeball.position.normalized() * 4
