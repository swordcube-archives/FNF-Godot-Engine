extends Node

var judgements:Dictionary = {
	"sick": {
		"time": 45.0,
		"score": 300,
		"noteSplash": true,
		"mod": 1.0,
		"healthMult": 1
	},
	"good": {
		"time": 90.0,
		"score": 200,
		"noteSplash": false,
		"mod": 0.7,
		"healthMult": 1
	},
	"bad": {
		"time": 135.0,
		"score": 100,
		"noteSplash": false,
		"mod": 0.4,
		"healthMult": 1
	},
	"shit": {
		"time": 180.0,
		"score": 50,
		"noteSplash": false,
		"mod": 0,
		"healthMult": -0.175
	},
}

var ranks:Dictionary = {
	100: "S+",
	90: "S",
	80: "A",
	70: "B",
	55: "C",
	35: "D",
	15: "E",
	5: "F",
	0: "L",
}

func get_rank(accuracy:float) -> String:
	if Global.total_notes > 0:
		var last_accuracy:int = 0
		var le_rank:String = ""
		for rank in ranks.keys():
			var min_accuracy:int = rank
			if min_accuracy <= accuracy && min_accuracy >= last_accuracy:
				last_accuracy = min_accuracy
				le_rank = ranks[rank]
		
		return le_rank
		
	return "N/A"
	
func judge_note(strum_time:float):
	var note_diff:float = abs(Conductor.position - strum_time) / Conductor.rate
	var last_judge:String = "no"
	
	for name in judgements.keys():
		if note_diff <= judgements[name].time && last_judge == "no":
			last_judge = name
			
	if last_judge == "no":
		var keys = judgements.keys()
		last_judge = keys[keys.size()-1]
		
	return last_judge
