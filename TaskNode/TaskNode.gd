extends Node
class_name TaskNode

var child_task_node:TaskNode
var parent_task_node:TaskNode
var flag_destroy:bool = false

func set_child(_new_task_node:TaskNode)->TaskNode:
	self.child_task_node = _new_task_node
	_new_task_node.parent_task_node = self
	add_child(_new_task_node)
	return child_task_node
	
func get_tail()->TaskNode:
	if child_task_node:
		return child_task_node.get_tail()
	else:
		return self

func set_tail(_task_node:TaskNode):
	get_tail().set_child(_task_node)
	
#虚函数
func run()->void:
	pass

func run_child()->void:
	if child_task_node:
		child_task_node.run()
	else:
		print("task finished")
		destroy_all()

func destroy_all()->void:
	if !flag_destroy:
		self.queue_free()
		flag_destroy = true
		# print("task ready to destroy")
	else:
		return
		
	if child_task_node:
		child_task_node.destroy_all()
	if parent_task_node:
		parent_task_node.destroy_all()
