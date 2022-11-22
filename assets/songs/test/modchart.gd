extends Modchart

var beat_interval:float = 2.0
@onready var pendelum = $pendelum

func _process_post(delta):
	var converted_time:float = ((Conductor.position + PlayState.note_offset) / (Conductor.crochet * beat_interval)) * PI
	if !PlayState.starting_song:
		pendelum.rotation = deg_to_rad(sin(converted_time) * 32)
