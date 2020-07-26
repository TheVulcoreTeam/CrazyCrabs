extends AnimatedSprite

var cook_timer_max := 1.5
var cook_timer_delay := 0.0

var cook_max_state := 2
var cook_state := 0

func _process(delta):
	
	if cook_state >= cook_max_state:
		return
	
	if cook_timer_delay < cook_timer_max:
		cook_timer_delay += delta 
	else:
		cook_state += 1
		frame = cook_state
		cook_timer_delay = 0.0
