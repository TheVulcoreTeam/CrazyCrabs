extends Node2D

var crab_source = preload("res://Game/Actors/Crab/Crab.tscn")

export var max_crab_count := 50
export var crab_count := 3

func _ready():
	randomize()
	
	for n in range(crab_count):
		spawn_crab()
	
	Events.connect("update_score", self, "_on_update_score")

func _process(delta):
	check_crab_bounds()

func spawn_crab():
	
	var crab = crab_source.instance()
	$Crabs.add_child(crab)
	
	var rand_position := MapManager.pot_center
	
	while(MapManager.negative_spawn_rect_bounds.has_point(rand_position)):
		
		rand_position.x = (MapManager.rect_bounds.position.x) + randi() % (MapManager.rect_bounds.size.x as int)
		rand_position.y = (MapManager.rect_bounds.position.y) + randi() % (MapManager.rect_bounds.size.y as int)
	
	crab.position = rand_position
	
	var dir_point := Vector2()
	dir_point.x = (MapManager.negative_spawn_rect_bounds.position.x) + randi() % (MapManager.negative_spawn_rect_bounds.size.x as int)
	dir_point.y = (MapManager.negative_spawn_rect_bounds.position.y) + randi() % (MapManager.negative_spawn_rect_bounds.size.y as int)
	
	crab.angle = crab.position.angle_to_point(dir_point) + (PI/2.0)
	crab.angle_vector = Vector2(0,1).rotated(crab.angle)
	crab.get_node("Sprite").rotation = crab.angle - (PI/2.0)
	
func check_crab_bounds():
	
	for child in $Crabs.get_children():
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
		Main.game_result = Main.GameResult.FINISH
		get_tree().change_scene("res://MainScreens/EndLevel.tscn")


func _on_SpawnerTimer_timeout():
	
	if ($Crabs.get_child_count() < max_crab_count):
		for i in range(3):
			spawn_crab()
			#print("SPAWNEO NUEVO")
	
	pass # Replace with function body.


func _on_DifficultTimer_timeout():
	crab_count += 3
	if crab_count > max_crab_count:
		crab_count = max_crab_count
	print("[CRAB COUNT] : ", crab_count)
	pass # Replace with function body.
