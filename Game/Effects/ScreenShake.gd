extends Node

var force = 1
var force_base = 0
var frames = 0
var started = false
var frame_counter = 0

func _ready():
	pass 

# init:
# esta funcion debe llamarse para ejecutar el el temblor de camara.
# frames: los cuadros que durara la animacion
# _force: la oscilacion random en ejes x e y
func init(frames: int, _force: int):
	self.frames = frames
	self.force_base = -_force
	self.force = (_force * 2) + 1 # si es n oscilara entre -n y n
	self.started = true
	

# Proceso:
# Se ejecutara solo despues de que se ejecuto init.
# durante los frames definidos se cambiara la posicion del stage de forma random
# a valores que oscilen dentro del rango definido en _force
# cuando termine el mismo script dejara a stage en su posicion incial y luego comete suicidio.
func _process(delta):
	if (started):
		if (frame_counter > frames):
			self.get_parent().position = Vector2(0, 0)
			self.get_parent().remove_child(self)
		else:
			self.get_parent().position = Vector2(force_base + randi() % force, force_base + randi() % force)
			frame_counter += 1
