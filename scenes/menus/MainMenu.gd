extends Node2D

var cur_selected:int = 0

@onready var camera:Camera2D = $Camera2D
@onready var buttons:Node2D = $UI/Buttons

func _ready():
	get_tree().paused = false
	Global.skipped_title = true
	Audio.play_music(Paths.music("menuMusic"))
	change_selection()
	
func _input(event):
	if Input.is_action_just_pressed("ui_up") || Input.is_action_just_released("wheel_up"):
		change_selection(-1)
		
	if Input.is_action_just_pressed("ui_down") || Input.is_action_just_released("wheel_down"):
		change_selection(1)
		
	if Input.is_action_just_pressed("ui_cancel"):
		Audio.play_sound(Paths.sound("menus/cancelMenu"))
		Global.switch_scene("menus/TitleScreen")
	
func change_selection(change:int = 0):
	cur_selected = wrap(cur_selected + change, 0, buttons.get_child_count())
	
	camera.position.y = buttons.get_child(cur_selected).position.y

	for i in buttons.get_child_count():
		if cur_selected == i:
			buttons.get_child(i).play("white")
		else:
			buttons.get_child(i).play("basic")
			
	Audio.play_sound(Paths.sound("menus/scrollMenu"))
