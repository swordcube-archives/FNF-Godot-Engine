extends Resource

class_name ModchartGroup

var modcharts:Array[Modchart] = []

func call_func(func_name:String, args:Array[Variant]):
	for m in modcharts:
		m.callv(func_name, args)

func add(modchart:Modchart):
	modcharts.append(modchart)
