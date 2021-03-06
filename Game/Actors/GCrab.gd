extends KinematicBody2D

class_name GCrab

onready var collision = $Collision

var mouse_position = Vector2(0, 0)
var is_capture := false

var capture_position = Vector2.ZERO
var capture_t = 0

var capture_time = 0
var capture_time_limit = 180

var angle := 0.0 # radianes
var angle_vector := Vector2(0,0)

var external_collision = null

###DEBUG ONLY
export var debug_radius := 10
export var debug_color_1 := Color(0.3,0.1,0.6) 
export var debug_color_2 := Color(0.6,0.1,0.3) 
export var debug_color_3 := Color(0.6,0.3,0.3) 
####
var velocity = 1

var rect_size
var crab_rect

var clickeable := true

onready var pot = get_tree().get_nodes_in_group("Pot")

func _ready():
	# Este randomize deberia ir en un lugar con mas jerarquia**
	randomize()
	velocity = 0.5 + (randf() * 1.5)
	new_random_angle()
	
	if pot and pot.size() > 0: pot = pot[0]

func _process(delta):
	if Main.DEBUG_ACTORS: update()
	if is_capture: 
		if pot and pot.cover_off:
			capture_time += 1
			if capture_time > capture_time_limit:
				capture_time_exceeded()
	if !is_capture and capture_time > 0:
		capture_time = 0
		
func _draw():
	if not Main.DEBUG_ACTORS:
		return
	
	draw_circle(Vector2(0,0), debug_radius, debug_color_1)
	draw_line(Vector2(0,0), angle_vector*(debug_radius+5), debug_color_2, 3)
	draw_circle(angle_vector*(debug_radius+5), 5.5, debug_color_3)

func _physics_process(delta):
	rect_size = 24
	crab_rect = Rect2(position-Vector2(rect_size/2, rect_size/2), Vector2(rect_size, rect_size))
	
	if Input.is_action_pressed("click_derecho") and Rect2(mouse_position, Vector2.ONE).intersects(crab_rect) and clickeable:
		# apply right rotation
		angle = $Sprite.rotation + (PI/2.0) + PI*0.1
		angle_vector = Vector2(0, 1).rotated(angle)
		$Sprite.rotation_degrees += 6
		$Sprite/Arrow.visible = true
		$Sprite.scale = Vector2(1.2, 1.2)
	elif Input.is_action_pressed("click_izquierdo") and Rect2(mouse_position, Vector2.ONE).intersects(crab_rect) and clickeable:
		# apply Left rotation
		angle = $Sprite.rotation - (PI/2.0) - PI*0.1
		angle_vector = Vector2(0, -1).rotated(angle)
		$Sprite.rotation_degrees -= 6
		$Sprite/Arrow.visible = true
		$Sprite.scale = Vector2(1.2, 1.2)
	elif is_capture:
		capture_t += delta*2
		if capture_t > 1: capture_t = 1
		
		self.position = capture_position.linear_interpolate(Vector2(194, 104), capture_t)
	else:
		external_collision = move_and_collide(angle_vector *velocity)
		
		$Sprite/Arrow.visible = false
		$Sprite.scale = Vector2(1, 1)
		
		if external_collision != null:
			# Aqui la logica para cambiar el angulo, por ahora es random
			new_random_angle()
			EffectManager.crash_effect(external_collision.position)
			if external_collision.collider.name == 'Pot':
				EffectManager.screen_shake(2, 1)

func new_random_angle():
	angle = randf() * 2 * PI
	angle_vector = Vector2(0,1).rotated(angle)
	$Sprite.rotation = angle - (PI/2.0)
	$Sprite.flip_v = !$Sprite.flip_v
	
	SoundManager.play_sound("HIT_CRAB_" + str(int(round(rand_range(1,3)))))

func capture():
	if !pot.is_exploding:
		is_capture = true
		capture_position = self.position
		$Collision.set_deferred("disabled", true)

		Main.store_crab_cooking_amount += 1
		#$ExitTime.start()
		clickeable = false
		
		if not Main.easter_egg:
			SoundManager.play_sound("AARGH_" + str(int(round(rand_range(1, 5)))), 1, false, 2.4)
		else:
			SoundManager.play_sound("AARGH_" + str(int(round(rand_range(1, 5)))), 1, false)
	
func capture_time_exceeded():
	pass


func _input(event):
	if event.is_action_pressed("click_izquierdo") or event.is_action_pressed("click_derecho"):
		mouse_position = event.position

