extends KinematicBody2D

class_name Pot

var cover_off := true
var cooked_crab := load("res://Game/Actors/Pot/CookedCrabs/CookedCrab.tscn")

var cooked_crabs_positions_ids := []

# Instancias de cangrejos en la olla
var cooked_crabs_instances := []

var last_crab_amount = 0
var last_cookbar_state = 0
var is_exploding = false
var invicibility_frames = 60
var invicivility_time = 0

var cook_bar_position = Vector2(-9, 44)

func _ready():
	cook_bar_progress(0)
	$Cover.hide()
#	$Cover/Anim.play("CoverOn")
	$Collision.disabled = true
	$CookBar.hide()
	$CrabCounter/Label.rect_pivot_offset = $CrabCounter/Label.rect_size/2
	

func _process(delta):
	if is_exploding:
		invicivility_time += 1
		if invicivility_time > invicibility_frames:
			is_exploding = false
		captured_clean()
		Main.store_crab_cooking_amount = 0
		last_crab_amount = Main.store_crab_cooking_amount
		if $CrabCounter/Label.text != str(Main.store_crab_cooking_amount):
			$CrabCounter/Label.text = str(Main.store_crab_cooking_amount)
	else:
		if last_crab_amount != Main.store_crab_cooking_amount:
			$CrabCounter/Label.text = str(Main.store_crab_cooking_amount)
			$CrabCounter/AnimationPlayer.stop()
			$CrabCounter/AnimationPlayer.play("counter_change")
			
			if Main.store_crab_cooking_amount <= 12:
				var add_amount = Main.store_crab_cooking_amount - last_crab_amount
				
				if add_amount > 0:
					for i in range(add_amount):
						captured_add()
				else:
					for i in range(-add_amount):
						captured_remove()
			
			
		last_crab_amount = Main.store_crab_cooking_amount 
		
		if not cover_off and Main.store_crab_cooking_amount > 0:
			cook_bar_progress(($CookingTime.wait_time - $CookingTime.time_left)/ $CookingTime.wait_time*100)
		
		if Input.is_action_just_pressed("ui_accept"):
			cover_off = false
			$Cover.show()
			$Cover/Anim.play_backwards("CoverOn")
			$Collision.disabled = false
			$CookingTime.start()
			SoundManager.play_sound("POT_ON")
			if Main.store_crab_cooking_amount > 0:
				$CookBar.show()
				cover_cook()
			else:
				cover_idle()
			print("press")
		elif Input.is_action_just_released("ui_accept"):
			cover_off = true
			$Cover/Anim.play("CoverOn")
			$Collision.disabled = true
			$CookingTime.stop()
			SoundManager.play_sound("POT_OFF")
			cook_bar_progress(0)
			$CookBar.hide()
			
	#		for crab in cooked_crabs_instances:
	#			if is_instance_valid(crab):
	##				cooked_crab.get_node("ExitTime").start()
	#				crab.is_capture = true

	if last_cookbar_state > 50:
		cook_bar_shake()
	
	last_cookbar_state = $CookBar/ProgressBar.value

func _on_CaptureArea_body_entered(body):
	if body is TNTCrab:
		is_exploding = true
		EffectManager.explosion_effect(body.position)
		body.free()
		EffectManager.screen_shake(60, 5)
		for crab in EffectManager.find_node_by_name(get_tree().get_root(), "Crabs").get_children():
			if crab is Crab and crab.is_capture:
				crab.capture_time = 180
				crab.capture_time_exceeded()
		Main.store_crab_cooking_amount = 0
		captured_clean()
		Main.store_crab_cooking_amount = 0
#		for crab in cooked_crabs_instances:
#			if is_instance_valid(crab):
##				cooked_crab.get_node("ExitTime").start()
#				crab.capture_time = 180

	elif cover_off and body is Crab and 'Crab' in body.name and !body.is_capture:
		body = body as Crab
		body.capture()
		cooked_crabs_instances.append(body)
		
		
func _on_CookingTime_timeout():
	var score_made = 1 * Main.store_crab_cooking_amount
	Main.store_score += score_made
	Main.store_time += 3 * Main.store_crab_cooking_amount
	Main.store_crab_cooking_amount = 0
	Events.emit_signal("update_score", Main.store_score)
	SoundManager.play_sound("COOKED_CRAB")

	if score_made > 0:
		EffectManager.score_effect(score_made)
	cook_bar_progress(0)
	$CookBar.hide()
	cover_idle()
	captured_clean()
	
	for crab in cooked_crabs_instances:
		if is_instance_valid(crab):
			crab.queue_free()

func escape_all():
	captured_clean()
	for crab in cooked_crabs_instances:
		if is_instance_valid(crab) and crab is Crab:
			crab.exit_from_pot()

func captured_clean():
	var children = $CookedCrabs.get_children()
	for child in children:
		child.free()
	cooked_crabs_positions_ids = []


func cook_bar_progress(_value):
	$CookBar/ProgressBar.value = _value


func cook_bar_shake():
	if $CookBar/ProgressBar.value < 50:
		$CookBar.rect_position = cook_bar_position
	else:
		var x = (randf()*2)-1
		var y = (randf()*2)-1
		$CookBar.rect_position = cook_bar_position + Vector2(x, y)


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


