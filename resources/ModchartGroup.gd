extends Resource

class_name ModchartGroup

var modcharts:Array[Modchart] = []

func call_func(func_name:String, args:Array[Variant]):
	var i:int = 0
	for m in modcharts:
		# If the modchart is dead, remove it from
		# the list and continue on
		if !is_instance_valid(m):
			modcharts.remove_at(i)
			continue
		m.callv(func_name, args)
		i += 1

func add(modchart:Modchart):
	modcharts.append(modchart)
