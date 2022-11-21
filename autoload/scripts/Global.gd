extends Node

var tree = get_tree()
var skipped_title:bool = false

var note_swag_width:float = 160 * 0.7

var save:Save = Save.new().bind("funkin", "swordcube")
var SONG:Song = ChartParser.loadSong("VANILLA", "bopeebo", "normal")

var accuracy:float = 0.0
var total_notes:int = 0
var total_hit:float = 0.0

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("GAME CLOSED!")
		print("SAVING SETTINGS...")
		Settings.flush()
		print("SAVED SETTINGS!")

func switch_scene(name:String, transition:bool = true):
	if transition:
		get_tree().paused = true
		Transition.trans_in(
			func timeout():
				get_tree().change_scene_to_file("res://scenes/"+name+".tscn")
				Transition.trans_out(
					func timeout():
						get_tree().paused = false
				)
		)
	else:
		get_tree().change_scene_to_file("res://scenes/"+name+".tscn")
