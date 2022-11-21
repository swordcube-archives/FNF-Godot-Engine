extends Node

@onready var music:AudioStreamPlayer = $Music

var playing_music:AudioStream

func play_sound(path:String, vol:float = 1.0):
	var clone:AudioClone = AudioClone.new()
	clone.stream = load(path)
	if vol <= 0: vol = 0.01
	clone.volume_db = linear_to_db(vol)
	get_tree().current_scene.add_child(clone)
	clone.play(0.0)

func play_music(path:String = "", vol:float = 1.0):
	if path != "":
		if playing_music != load(path):
			playing_music = load(path)
			music.stream = playing_music
			if vol <= 0: vol = 0.01
			music.volume_db = linear_to_db(vol)
			music.play(0.0)
	else:
		music.stream_paused = false
	
func pause_music():
	music.stream_paused = true
	
func resume_music():
	music.stream_paused = false
