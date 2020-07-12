extends KinematicBody2D

class_name Pot

var cover_off := true

var last_crab_amount = 0

func _ready():
	cook_bar_progress(0)
	$CrabCounter/Label.rect_pivot_offset = $CrabCounter/Label.rect_size/2

func _process(delta):
	if last_crab_amount != Main.store_crab_cooking_amount:
		$CrabCounter/Label.text = str(Main.store_crab_cooking_amount)
		$CrabCounter/AnimationPlayer.stop()
		$CrabCounter/AnimationPlayer.play("counter_change")
	last_crab_amount = Main.store_crab_cooking_amount
	
	if not cover_off and Main.store_crab_cooking_amount > 0:
		cook_bar_progress(($CookingTime.wait_time - $CookingTime.time_left)/ $CookingTime.wait_time*100)
	
	if Input.is_action_just_pressed("ui_accept"):
		cover_off = false
		
		$Cover/Anim.play_backwards("CoverOn")
		$Collision.disabled = false
		$CookingTime.start()
		SoundManager.play_sound("POT_ON")
	elif Input.is_action_just_released("ui_accept"):
		cover_off = true
		$Cover/Anim.play("CoverOn")
		$Collision.disabled = true
		$CookingTime.stop()
		SoundManager.play_sound("POT_OFF")
		cook_bar_progress(0)

func cook_bar_progress(_value):
	$CookBar/ProgressBar.value = _value

func _on_CaptureArea_body_entered(body):
	if cover_off and body is GCrab:
		body = body as GCrab
		body.capture()
		
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
	
