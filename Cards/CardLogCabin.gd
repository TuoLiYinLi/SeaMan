extends Card
class_name CardLogCabin

# 激活场上的这张卡片
func activate()->void:
	print("activate%s"%self)
	pass

func on_start_phase():
	
	pass

func on_end_phase():
	GameManager.fish += 1
	pass
