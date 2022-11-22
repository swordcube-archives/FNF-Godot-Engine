extends Node2D

var cur_selected:int = 0
var cur_difficulty:int = 0

@export var song_list:Array[Resource] = []

@onready var bg:Sprite2D = $BG
@onready var grp_songs:Node2D = $Songs

@onready var score_bg:ColorRect = $ScoreBG
@onready var score_txt:Label = $ScoreTxt
@onready var diff_txt:Label = $DiffTxt

var lerp_score:float = 0.0

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
		text.is_menu_item = true
		text.target_y = i
		text.modulate.a = 0.6
		grp_songs.add_child(text)
		
		var icon:HealthIcon = text.get_node("Icon")
		icon.icon = song.icon
		icon.update_icon()
		icon.position.x = text.size.x + 65
		i += 1
		
	change_selection()
	
func change_selection(change:int = 0):
	Audio.play_sound(Paths.sound("menus/scrollMenu"))
	grp_songs.get_child(cur_selected).modulate.a = 0.6
	cur_selected = wrap(cur_selected + change, 0, song_list.size())
	grp_songs.get_child(cur_selected).modulate.a = 1
	
	var i:int = 0
	for child in grp_songs.get_children():
		child.target_y = i - cur_selected
		i += 1
		
	change_difficulty()
		
func change_difficulty(change:int = 0):
	cur_difficulty = wrap(cur_difficulty + change, 0, song_list[cur_selected].difficulties.size())
	diff_txt.text = '< '+song_list[cur_selected].difficulties[cur_difficulty].to_upper()+' >';
	position_highscore()

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Audio.play_sound(Paths.sound("menus/cancelMenu"))
		Global.switch_scene("menus/MainMenu")
		
	if Input.is_action_just_pressed("ui_up") || Input.is_action_just_released("wheel_up"):
		change_selection(-1)
		
	if Input.is_action_just_pressed("ui_down") || Input.is_action_just_released("wheel_down"):
		change_selection(1)
		
	if Input.is_action_just_pressed("ui_left"):
		change_difficulty(-1)
		
	if Input.is_action_just_pressed("ui_right"):
		change_difficulty(1)
		
	if Input.is_action_just_pressed("ui_accept"):
		Audio.stop_music()
		Global.is_story_mode = false
		Global.SONG = ChartParser.loadSong(song_list[cur_selected].chart_type, song_list[cur_selected].song, song_list[cur_selected].difficulties[cur_difficulty])
		Global.switch_scene("PlayState")
		
func position_highscore():
	score_txt.size.x = 0.0
	score_txt.text = "PERSONAL BEST:"+str(round(lerp_score))
	score_txt.position.x = 1280 - score_txt.size.x - 6
	score_bg.scale.x = 1280 - score_txt.position.x + 6
	score_bg.position.x = 1280 - score_bg.scale.x
	diff_txt.position.x = score_bg.position.x + (score_bg.scale.x+1) / 2
	diff_txt.position.x -= diff_txt.size.x / 2

func _process(delta):
	var name:String = song_list[cur_selected].song
	var diff:String = song_list[cur_selected].difficulties[cur_difficulty]
	lerp_score = lerp(lerp_score, float(Highscore.grab(name+'-'+diff)), clamp(delta * 60 * 0.4, 0, 1))
	position_highscore()
	bg.modulate = lerp(bg.modulate, song_list[cur_selected].bg_color, clamp(delta * 60 * 0.045, 0, 1))
