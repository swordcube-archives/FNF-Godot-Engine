extends Node

var scores:Dictionary = {}

func _ready():
	if Settings.grab("scores") != null:
		scores = Settings.grab("scores")
	else:
		Settings.assign("scores", scores)

func grab(score:String) -> int:
	if scores.has(score):
		return scores[score]
		
	return 0
	
func assign(score:String, value:int):
	scores[score] = value
	
func flush():
	Settings.flush()
