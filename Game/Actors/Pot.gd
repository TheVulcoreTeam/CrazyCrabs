extends KinematicBody2D

class_name Pot

var cover_off := false
var cooked_crab := load("res://Game/Actors/Pot/CookedCrabs/CookedCrab.tscn")

var cooked_crabs_positions_ids := []

var last_crab_amount = 0

func _ready():
	cook_bar_progress(0)
	$CookBar.hide()
	$CrabCounter/Label.rect_pivot_offset = $CrabCounter/Label.rect_size/2


func _process(delta):
	if last_crab_amount != Main.store_crab_cooking_amount:
		$CrabCounter/Label.text = str(Main.store_crab_cooking_amount)
		$CrabCounter/AnimationPlayer.stop()
		$CrabCounter/AnimationPlayer.play("counter_change")
	last_crab_amount = Main.store_crab_cooking_amount
	
	if not cover_off and Main.store_crab_cooking_amount > 0:
		cook_bar_progress(($CookingTime.wait_time - $CookingTime.time_left)/ $CookingTime.wait_time*100)

func cook_bar_progress(_value):
	$CookBar/ProgressBar.value = _value

func cover_idle():
	$Cover.play("idle")

func cover_cook():
	$Cover.play("cook")

func captured_add():
	if $CookedCrabs.get_child_count() >= 12:
		return
	
	var rand_i = randi() % 12
	
	if cooked_crabs_positions_ids.has(rand_i):
		rand_i = 0
		while (cooked_crabs_positions_ids.has(rand_i) and rand_i < 11):
			rand_i += 1
	
	var instance = cooked_crab.instance()
	$CookedCrabs.add_child(instance)
	instance.position = $CookedCrabsPositions.get_node(rand_i as String).position
	instance.name = rand_i as String
	cooked_crabs_positions_ids.append(rand_i)

func captured_remove(id := -1):
	var child_count = $CookedCrabs.get_child_count()
	if child_count >= 12 or child_count <= 0:
		return
	
	id = randi() % child_count
	
	var children = $CookedCrabs.get_children()
	cooked_crabs_positions_ids.erase(children[id].name as int)
	children[id].queue_free()
	

func captured_clean():
	var children = $CookedCrabs.get_children()
	for child in children:
		child.queue_free()

func _on_TouchArea_pressed():
	if not $Cover/Anim.is_playing():
		cover_off = not cover_off
		
		if cover_off:
			$Cover/Anim.play("CoverOn")
			$Collision.disabled = true
			$CookingTime.stop()
			SoundManager.play_sound("POT_OFF")
			cook_bar_progress(0)
			cover_idle()
			$CookBar.hide()
		else:
			$Cover/Anim.play_backwards("CoverOn")
			$Collision.disabled = false
			$CookingTime.start()
			SoundManager.play_sound("POT_ON")
			if Main.store_crab_cooking_amount > 0:
				$CookBar.show()
				cover_cook()
			else:
				cover_idle()

func _on_CaptureArea_body_entered(body):
	if cover_off and body is GCrab:
		body = body as GCrab
		body.capture()
		captured_add()
		
func _on_CookingTime_timeout():
	var score_made = 1 * Main.store_crab_cooking_amount
	Main.store_score += score_made
	Main.store_time += 5 * Main.store_crab_cooking_amount
	Main.store_crab_cooking_amount = 0
	print_debug(Main.store_crab_cooking_amount)
	Events.emit_signal("update_score", Main.store_score)
	SoundManager.play_sound("COOKED_CRAB")

	if score_made > 0:
		EffectManager.score_effect(score_made)
	cook_bar_progress(0)
	$CookBar.hide()
	cover_idle()
	captured_clean()
