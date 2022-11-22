extends Node

class_name Modchart

var PlayState:PlayState

static func create(path:String, instance:PlayState):
	var modchart:Modchart = load(path).instantiate()
	modchart.PlayState = instance
	instance.add_child(modchart)
	return modchart
	
func _process_post(delta:float):
	pass

func _beat_hit(beat:int):
	pass
	
func _step_hit(step:int):
	pass
	
func _beat_hit_post(beat:int):
	pass
	
func _step_hit_post(step:int):
	pass
