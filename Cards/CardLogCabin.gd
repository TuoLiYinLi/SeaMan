extends Card
class_name CardLogCabin

# 激活场上的这张卡片
func activate():
	print("activate%s"%self)

func on_start_phase():
	
	return

func on_end_phase():
	GameManager.fish += 1
	pass


