extends TaskNode
class_name TaskNodeBlocking

var flag_run:bool = false 

func run():
	flag_run = true
	print("start blocking")
	
func _process(delta):
	if !flag_run:
		return
	else:
		blocking()

# 虚函数,正在阻塞时运行
func blocking():
	print("blocking")

func exit_blocking():
	run_child()
	flag_run = false
