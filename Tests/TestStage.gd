extends Node2D

var crab_source = preload("res://Game/Actors/Crab/Crab.tscn")

export var crab_count := 10
export var rect_bound = Rect2(0, 0, 400, 200)

func _ready():
	randomize()
	
	for n in range(crab_count):
		spawn_crab()
	
	pass # Replace with function body.

func _process(delta):
	check_crab_bounds()

func spawn_crab():
	
	var crab = crab_source.instance()
	add_child(crab)
	
	crab.position.x = (rect_bound.position.x) + randi() % (rect_bound.size.x as int)
	crab.position.y = (rect_bound.position.y) + randi() % (rect_bound.size.y as int)

func check_crab_bounds():
	
	for child in get_children():
		if not (child is GCrab):
			continue
		if not rect_bound.has_point(child.position):
			child.queue_free()
			spawn_crab()
