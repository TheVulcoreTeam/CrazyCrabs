extends Node2D

var crab_source = preload("res://Game/Actors/Crab/Crab.tscn")

export var crab_count := 10

func _ready():
	randomize()
	
	for n in range(crab_count):
		spawn_crab()
	
	Events.connect("update_score", self, "_on_update_score")

func _process(delta):
	check_crab_bounds()

func spawn_crab():
	
	var crab = crab_source.instance()
	add_child(crab)
	
	var rand_position := MapManager.pot_center
	
	while(MapManager.pot_center.distance_squared_to(rand_position) < MapManager.pot_radius*MapManager.pot_radius):
		
		rand_position.x = (MapManager.rect_bounds.position.x) + randi() % (MapManager.rect_bounds.size.x as int)
		rand_position.y = (MapManager.rect_bounds.position.y) + randi() % (MapManager.rect_bounds.size.y as int)
	
	crab.position = rand_position
	#print(MapManager.pot_center.distance_to(rand_position))
	
func check_crab_bounds():
	
	for child in get_children():
		if not (child is GCrab):
			continue
		if not MapManager.rect_bounds.has_point(child.position):
			child.queue_free()
			spawn_crab()

func _on_update_score(score):
	$Score.text = "Score: " + str(score)

func _on_Countdown_timeout():
	Main.store_time -= 1
	$Time.text = "Time: " + str(Main.store_time)
	
	if Main.store_time <= 0:
		get_tree().change_scene("res://MainScreens/EndLevel.tscn")
