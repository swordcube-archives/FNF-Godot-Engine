extends Node2D

var cur_selected:int = 0
var selecting:bool = false

@onready var magenta:Sprite2D = $PBG/PL1/Magenta
@onready var camera:Camera2D = $Camera2D
@onready var buttons:Node2D = $UI/Buttons

func _ready():
	get_tree().paused = false
	Global.skipped_title = true
	Audio.play_music(Paths.music("menuMusic"))
	change_selection()
	
func _input(event):
	if not selecting:
		if Input.is_action_just_pressed("ui_up") || Input.is_action_just_released("wheel_up"):
			change_selection(-1)
			
		if Input.is_action_just_pressed("ui_down") || Input.is_action_just_released("wheel_down"):
			change_selection(1)
			
		if Input.is_action_just_pressed("ui_cancel"):
			Audio.play_sound(Paths.sound("menus/cancelMenu"))
			Global.switch_scene("menus/TitleScreen")
			
		if Input.is_action_just_pressed("ui_accept"):
			select_option()
			
func select_option():
	selecting = true
	EasyFlicker.new().start(magenta, 1.1, 0.15, false)
	Audio.play_sound(Paths.sound("menus/confirmMenu"))
	
	var button = buttons.get_child(cur_selected)
	var flick:EasyFlicker = EasyFlicker.new().start(button, 1, 0.06, false)
	flick.connect("finished", func():
		for child in buttons.get_children():
			var tween = get_tree().create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(child, "modulate:a", 0, 0.5)
		
		EasyTimer.new().start(0.55, func(tmr:EasyTimer):
			match str(button.name):
				"Story Mode":
					pass
				"Freeplay":
					Global.switch_scene("menus/FreeplayMenu")
				"Options":
					pass	
		)
	)
	
func change_selection(change:int = 0):
	buttons.get_child(cur_selected).play("basic")
	cur_selected = wrap(cur_selected + change, 0, buttons.get_child_count())
	buttons.get_child(cur_selected).play("white")
	
	camera.position.y = buttons.get_child(cur_selected).position.y
			
	Audio.play_sound(Paths.sound("menus/scrollMenu"))
