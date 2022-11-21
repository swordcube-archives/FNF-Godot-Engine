extends Node2D

@onready var logo:AnimatedSprite2D = $Objects/logo
@onready var gf:AnimationPlayer = $Objects/gf/AnimationPlayer
@onready var title_enter:AnimatedSprite2D = $Objects/titleEnter
@onready var grpText:Node2D = $Text
@onready var textTemplate:Alphabet = $TextTemplate

var cur_display_text:PackedStringArray = [
	"big booty",
	"baller"
]

var flash_tween:Tween

var confirmed:bool = false
var started_intro:bool = false

func load_intro_text() -> PackedStringArray:
	var f = FileAccess.open(Paths.txt("data/introText"), FileAccess.READ)
	if f:
		var split:PackedStringArray = f.get_as_text().split("\n")
		var cool_lines:PackedStringArray = split[randi_range(0, split.size()-1)].split("--")
		return cool_lines
	
	var ret_array:PackedStringArray = [
		"fallback exclusive", 
		"intro text"
	]
	return ret_array

func _ready():
	Conductor.position = -50
	
	Conductor.change_bpm(102.0)
	Conductor.connect("beat_hit", func b(): beat_hit(Conductor.cur_beat))
	title_enter.play("idle")
	
	cur_display_text = load_intro_text()
	
	await get_tree().create_timer(1.0).timeout
	started_intro = true
	Audio.play_music(Paths.music("menuMusic"))
	if Global.skipped_title:
		skip_intro()
	
func _process(delta):
	if started_intro:
		if Audio.music.playing:
			Conductor.position = Audio.music.get_playback_position() * 1000.0
		else:
			Conductor.position += delta * 1000.0
			
func _input(event):
	if started_intro && Input.is_action_just_pressed("ui_accept"):
		if !Global.skipped_title:
			Global.skipped_title = true
			skip_intro()
		else:
			if !confirmed:
				confirmed = true
				finish()
			
func finish():
	title_enter.play("pressed")
	Audio.play_sound(Paths.sound("menus/confirmMenu"))
	
	if !flash_tween:
		flash_tween = get_tree().create_tween()
		$Flash.modulate.a = 1
		flash_tween.tween_property($Flash, "modulate:a", 0, 2)
	
	EasyTimer.new().start(2, func(tmr:EasyTimer):
		Global.switch_scene("menus/MainMenu")
	)
	
func create_text(text:PackedStringArray):
	for item in text: add_text(item)
	
func add_text(text:String):
	var baller:Alphabet = textTemplate.duplicate()
	baller.text = text
	baller.position.y += (grpText.get_child_count() * 60) + 200
	baller.visible = true
	grpText.add_child(baller)
	baller.screen_center("X")
	
func remove_text():
	for child in grpText.get_children(): child.queue_free()

var danced:bool = false
func beat_hit(beat:int):
	logo.frame = 0
	logo.play("logo bumpin")
	danced = !danced
	if danced:
		gf.play("danceLeft")
	else:
		gf.play("danceRight")
	gf.seek(0)
	
	if !Global.skipped_title:
		match beat:
			1:
				create_text(["swordcube", "the dev"])
			3:
				add_text("presents")
			4:
				remove_text()
			5:
				create_text(["You should", "go check out"])
			7:
				$ngLogo.visible = true
				add_text("Newgrounds")
			8:
				$ngLogo.visible = false
				remove_text()
			9:
				add_text(cur_display_text[0])
			11:
				add_text(cur_display_text[1])
			12:
				remove_text()
			13:
				add_text("Friday")
			14:
				add_text("Night")
			15:
				add_text("Funkin")
			_:
				if beat >= 16: skip_intro()

func skip_intro():
	if !Global.skipped_title:
		Global.skipped_title = true
		
	flash_tween = get_tree().create_tween()
	$Flash.modulate.a = 1
	flash_tween.tween_property($Flash, "modulate:a", 0, 4)
	get_tree().create_timer(4.05).connect("timeout", func():
		flash_tween = null
	)
		
	$Objects.visible = true
	remove_text()
