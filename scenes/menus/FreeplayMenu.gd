extends Node2D

@export var song_list:Array[Resource] = []
@onready var grp_songs:Node2D = $Songs

func _ready():
	Global.skipped_title = true
	Audio.play_music(Paths.music("menuMusic"))
	
	var template = $SongTemplate
	var i:int = 0
	for song in song_list:
		var text:Alphabet = template.duplicate()
		text.text = song.song
		text.visible = true
		text.position = Vector2(0, (70 * i) + 30)
		grp_songs.add_child(text)
		
		var icon:HealthIcon = text.get_node("Icon")
		icon.icon = song.icon
		icon.position.x = text.size.x + 65
		i += 1

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Audio.play_sound(Paths.sound("menus/cancelMenu"))
		Global.switch_scene("menus/MainMenu")
