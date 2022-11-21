extends Node

var settings:Dictionary = {
	# Preferences
	"downscroll": false,
	"centered-notes": false,
	"ghost-tapping": true,
	
	# Appearance (Judgements)
	"judgement-camera": "World",
	"judgement-counter": "Left",
	# Appearance (Notes)
	"sustain-layer": "Behind",
	"note-skin": "Arrows",
	"enable-note-splashes": true,
	
	# Appearance (Accessibility)
	"flashing-lights": true,
	"enable-antialiasing": true,
	
	# Controls
	"game_1": ["SPACE"],
	"game_2": ["D", "K"],
	"game_3": ["D", "SPACE", "K"],
	"game_4": ["D", "F", "J", "K"],
	
	# General (Might be used in other games by me)
	"volume": 1,
	"muted": false
}

func setup_binds():
	Input.set_use_accumulated_input(false)
	
	if not "key_amount" in Global.SONG:
		Global.SONG.key_amount = 4
	
	var binds = grab("game_" + str(Global.SONG.key_amount))
	
	for action_num in Global.SONG.key_amount:
		var action = "game_" + str(action_num)
		
		var keys = InputMap.action_get_events(action)
		
		var new_Event = InputEventKey.new()
		# set key to the scancode of the key
		new_Event.set_keycode(OS.find_keycode_from_string(binds[action_num].to_lower()))
		
		if keys.size() - 1 != -1: # error handling shit i forgot the cause of lmao
			InputMap.action_erase_event(action, keys[keys.size()-1])
		else:
			InputMap.add_action(action)
		
		InputMap.action_add_event(action, new_Event)

func _ready():
	var save:Save = Global.save
	var do_flush:bool = false
	for key in settings.keys():
		if save.grab(key) != null:
			assign(key, save.grab(key))
		else:
			do_flush = true
			save.assign(key, settings[key])
			
	if do_flush: save.flush()
	setup_binds()

func grab(name:String):
	if settings.has(name):
		return settings[name]
		
	return null
	
func assign(name:String, value:Variant):
	settings[name] = value
	
func flush():
	Global.save.flush()
