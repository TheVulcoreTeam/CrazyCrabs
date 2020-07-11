extends Node

var current_music : AudioStreamPlayer

enum Music {
	TITLE_SCREEN,
	LEVEL_PACK_1,
	LEVEL_PACK_2,
	LEVEL_PACK_3,
	ENDING,
	GAME_OVER,
	WIN
}
var music

func play(music_enum):
	if not Main.BGM or music_enum == music:
		return
	
	music = music_enum
	
	if current_music: current_music.stop()
	
	match music_enum:
		Music.TITLE_SCREEN: current_music = $TitleScreen
		Music.LEVEL_PACK_1: current_music = $LevelPack1
		Music.LEVEL_PACK_2: current_music = $LevelPack2
		Music.LEVEL_PACK_3: current_music = $LevelPack3
		Music.ENDING: current_music = $Ending
		Music.GAME_OVER: current_music = $GameOver
		Music.WIN: current_music = $Win
	
	current_music.play()
