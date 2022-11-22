extends Modchart

var can_hit:bool = true
var beat_interval:float = 2.0
var fuck_ups:int = 0
var misses:int = 0
@onready var pendelum = $pendelum
@onready var copies = $copies
@onready var static_bg = $static
@onready var annoying = $annoying

func _ready():
	annoying.volume_db = -1000
	annoying.play()
	
	var allowed_songs:PackedStringArray = [
		"Test"
	]
	
	if !PlayState.SONG.name in allowed_songs:
		queue_free() # Stop the modchart from running in disallowed songs

func _process(delta):
	static_bg.modulate.a = 1 * (fuck_ups * 0.03)
	annoying.volume_db = linear_to_db(clamp(1 * (clamp(fuck_ups-4, 0, 9999) * 0.01), 0, 1))
	var converted_time:float = ((Conductor.position + PlayState.note_offset) / (Conductor.crochet * beat_interval)) * PI
	if !PlayState.starting_song:
		var rot_shit:float = sin(converted_time) * 32
		pendelum.rotation = deg_to_rad(rot_shit)
		
		if abs(rot_shit) > 20:
			can_hit = true
		
		if Input.is_action_just_pressed("pendelum"):
			if abs(rot_shit) <= 20:
				if can_hit: good_hit()
			else:
				bad_hit()
				
	if static_bg.modulate.a >= 1:
		# no death screen yet
		# so we just instantly end the song
		PlayState.end_song()
				
func good_hit():
	print("good hit!")
	can_hit = false
	misses = 0
	var dupe = pendelum.duplicate()
	dupe.modulate.a = 0.5
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(dupe, "modulate:a", 0, 0.3)
	tween.tween_callback(func(): if is_instance_valid(dupe): dupe.queue_free())
	copies.add_child(dupe)
	fuck_ups -= 1
	if fuck_ups <= 0: fuck_ups = 0
	
func bad_hit():
	fuck_ups += 1
	print("bad hit!")

func _beat_hit(beat:int):
	if beat % 2 == 0:
		if misses > 0:
			if Input.is_action_pressed("pendelum") && can_hit:
				return
			fuck_ups += 1
			print("you failed to hit in time!")
			
		misses += 1
