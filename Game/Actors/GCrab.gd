extends KinematicBody2D

class_name GCrab

var is_capture := false

var angle := 0.0 # radianes
var angle_vector := Vector2(0,0)

###DEBUG ONLY
export var debug_radius := 10
export var debug_color_1 := Color(0.3,0.1,0.6) 
export var debug_color_2 := Color(0.6,0.1,0.3) 
export var debug_color_3 := Color(0.6,0.3,0.3) 
####

func _ready():
	# Este randomize deberia ir en un lugar con mas jerarquia**
	randomize()
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
	var collision := move_and_collide(angle_vector)

	if collision != null:
		# Aqui la logica para cambiar el angulo, por ahora es random
		new_random_angle()

func new_random_angle():
	angle = randf() * 2 * PI
	angle_vector = Vector2(0,1).rotated(angle)
#	$Sprite.rotate(angle)

func capture():
	is_capture = true
	$Collision.disabled = true
