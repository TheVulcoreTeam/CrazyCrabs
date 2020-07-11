extends KinematicBody2D

class_name GCrab

onready var collision = $Collision

var mouse_position = Vector2(0, 0)
var is_capture := false

var capture_position = Vector2.ZERO
var capture_t = 0

var angle := 0.0 # radianes
var angle_vector := Vector2(0,0)

###DEBUG ONLY
export var debug_radius := 10
export var debug_color_1 := Color(0.3,0.1,0.6) 
export var debug_color_2 := Color(0.6,0.1,0.3) 
export var debug_color_3 := Color(0.6,0.3,0.3) 
####
var velocity = 1

func _ready():
	# Este randomize deberia ir en un lugar con mas jerarquia**
	randomize()
	velocity = 0.5+(randf()*1.5)
	new_random_angle()

func _process(delta):
	if Main.DEBUG_ACTORS: update()

func _draw():
	if not Main.DEBUG_ACTORS:
		return
	
	draw_circle(Vector2(0,0), debug_radius, debug_color_1)
	draw_line(Vector2(0,0), angle_vector*(debug_radius+5), debug_color_2, 3)
	draw_circle(angle_vector*(debug_radius+5), 5.5, debug_color_3)

func _physics_process(delta):
	var rect_size = 16
	var crab_rect = Rect2(position-Vector2(rect_size/2, rect_size/2), Vector2(rect_size, rect_size))
	
	if Input.is_action_pressed("click_derecho") and Rect2(mouse_position, Vector2.ONE).intersects(crab_rect):
		# apply right rotation
		angle = $Sprite.rotation + (PI/2.0) + PI*0.1
		angle_vector = Vector2(0, 1).rotated(angle)
		$Sprite.rotation_degrees += 10
		$Sprite/Arrow.visible = true
		$Sprite.scale = Vector2(1.2, 1.2)
		EffectManager.screen_shake(1, 1)
	elif Input.is_action_pressed("click_izquierdo") and Rect2(mouse_position, Vector2.ONE).intersects(crab_rect):
		# apply Left rotation
		angle = $Sprite.rotation - (PI/2.0) - PI*0.1
		angle_vector = Vector2(0, -1).rotated(angle)
		$Sprite.rotation_degrees -= 10
		$Sprite/Arrow.visible = true
		$Sprite.scale = Vector2(1.2, 1.2)
		EffectManager.screen_shake(1, 1)
	elif is_capture:
		capture_t += delta*2
		self.position = capture_position.linear_interpolate(Vector2(194, 104), capture_t)
		
	else:
		var collision := move_and_collide(angle_vector *velocity)
		
		$Sprite/Arrow.visible = false
		$Sprite.scale = Vector2(1, 1)
		
		if collision != null:
			# Aqui la logica para cambiar el angulo, por ahora es random
			new_random_angle()

func new_random_angle():
	angle = randf() * 2 * PI
	angle_vector = Vector2(0,1).rotated(angle)
	$Sprite.rotation = angle - (PI/2.0)
	$Sprite.flip_v = !$Sprite.flip_v
	
	SoundManager.play_sound("IMPACT")

func capture():
	is_capture = true
	capture_position = self.position
	$Collision.disabled = true
	$CookingTime.start()

func _on_CookingTime_timeout():
	Main.store_score += 1
	Events.emit_signal("update_score", Main.store_score)
	SoundManager.play_sound("ADD_SCORE")
	queue_free()
	
func _input(event):
	mouse_position = event.position
