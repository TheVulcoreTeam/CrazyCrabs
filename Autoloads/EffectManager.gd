extends Node

var screen_shake = preload("res://Game/Effects/ScreenShake.tscn")
var crash = preload("res://Game/Effects/Crash.tscn")

func screen_shake(frames: int, force: int):
	var screen_shake_instance = screen_shake.instance()
	screen_shake_instance.init(frames, force)
	var node = find_node_by_name(get_tree().get_root(), "Stage")
	node.add_child(screen_shake_instance)

func find_node_by_name(root, name):
	if(root.get_name() == name): return root

	for child in root.get_children():
		if(child.get_name() == name):
			return child

		var found = find_node_by_name(child, name)

		if(found): return found

	return null
	
func crash_effect(position : Vector2):
	var crash_instance = crash.instance()
	var node = find_node_by_name(get_tree().get_root(), "Stage")
	node.add_child(crash_instance)
	crash_instance.position = position
