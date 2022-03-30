# 用于显示和更新资源数值
extends Node2D
class_name ResourcePivot

var node_fish_num:RichTextLabel
var node_wood_num:RichTextLabel
var node_sanity_num:RichTextLabel
var node_health_num:RichTextLabel


func _ready():
	node_fish_num = $fish_pivot/fish_num
	node_wood_num = $wood_pivot/wood_num
	node_sanity_num = $sanity_pivot/sanity_num
	node_health_num = $health_pivot/health_num

func _process(delta):
	GameManager.check_resources()
	renew_all()

func renew_all():
	renew_fish()
	renew_wood()
	renew_sanity()
	renew_health()

func renew_fish():
	node_fish_num.text = String(GameManager.fish) + "/" + String(GameManager.fish_max())


func renew_wood():
	node_wood_num.text = String(GameManager.wood) + "/" + String(GameManager.wood_max())


func renew_sanity():
	node_sanity_num.text = String(GameManager.sanity)


func renew_health():
	node_health_num.text = String(GameManager.health)
