extends TaskNode
class_name TaskNodeSimple

func run():
	job()
	run_child()

#虚函数
func job():
	print("job")
