extends Label

func renew(day:int,period:int):
	text = "第%s轮\n第%s天" % [day, period]
	
func _process(delta):
	renew(GameManager.period_num, GameManager.day_num)
