extends Node

const PATH = "res://Sounds/SFX/"
const EXTENSION = "ogg"
# Extension en android 
const EXTENSION_ANDROID = "import"

# Array de sonidos precargados
var sounds = {}

func _ready():
	# Obtener la ruta de los sonidos y añadirla a un array
	#
	
	var dir = Directory.new()

	if dir.open(PATH) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name.get_extension() == EXTENSION or file_name.get_extension() == "import":
				var file_name_to_load : String
				var file_name_key : String
				
				if OS.get_name() == "Android":
					file_name_to_load = (dir.get_current_dir() + "/" + file_name).replace("." + EXTENSION_ANDROID, "")
					file_name_key = file_name.replace("." + EXTENSION + "." + EXTENSION_ANDROID, "")
					sounds[file_name_key] = load(file_name_to_load)
				if OS.get_name() == "HTML5":
					file_name_to_load = (dir.get_current_dir() + "/" + file_name).replace("." + EXTENSION_ANDROID, "")
					file_name_key = file_name.replace("." + EXTENSION + "." + EXTENSION_ANDROID, "")
					sounds[file_name_key] = load(file_name_to_load)
					print_debug(file_name_to_load)
				elif file_name.get_extension() == EXTENSION:
					file_name_to_load = (dir.get_current_dir() + file_name)
					file_name_key = file_name.replace("." + EXTENSION, "")
					sounds[file_name_key] = load(file_name_to_load)
			file_name = dir.get_next()
	
# Nombre del sonido a ejecutar sin extenciòn .ogg,
# por ejemplo GOOD_BLOCK_KILL
func play_sound(sound_name : String, volume_db := 0.0, loop := false, pitch_scale := 1.0):
	var sound = AudioStreamPlayer.new()
	sound.bus = "SFX"
	add_child(sound)
	
	if sounds.has(sound_name):
		sound.stream = sounds[sound_name]

	if not sound.stream:
		return

	sound.volume_db = volume_db
	sound.stream.loop = loop
	sound.pitch_scale = pitch_scale
	sound.play()

	sound.connect("finished", self, "_on_sound_finished", [sound])
	
func _on_sound_finished(sound):
	sound.queue_free()
