extends Node

const DEBUG_ACTORS := false

const BGM := true

var store_score := 0
var store_time := 60

func _ready():
	MusicManager.play(MusicManager.Music.GAME)

func reset_store():
	store_score = 0
	store_time = 60
