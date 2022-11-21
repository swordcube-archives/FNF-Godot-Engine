extends Node2D

@onready var opponent_strums:StrumLine = $UI/OpponentStrums
@onready var player_strums:StrumLine = $UI/PlayerStrums

@onready var inst:AudioStreamPlayer = $Inst
@onready var voices:AudioStreamPlayer = $Voices

var SONG = Global.SONG
var unspawn_notes:Array[UnspawnNote] = []

var skipped_intro:bool = false
var starting_song:bool = true

var og_speed:float = 0.0

func _ready():
	inst.stream = load(Paths.inst(SONG.name))
	voices.stream = load(Paths.voices(SONG.name))
	
	inst.pitch_scale = Conductor.rate
	voices.pitch_scale = Conductor.rate
	
	Settings.setup_binds()
	
	Conductor.change_bpm(SONG.bpm)
	Conductor.position = Conductor.crochet * -5.0
	
	if !Settings.grab("downscroll"):
		opponent_strums.position.y = 95
		player_strums.position.y = 95
	
	for section in SONG.sections:
		for note in section.notes:
			var gotta_hit:bool = section.player_section
			if note.direction > (SONG.key_amount - 1):
				gotta_hit = !section.player_section
				
			var data:UnspawnNote = UnspawnNote.new()
			data.strum_time = note.strum_time
			data.direction = note.direction % SONG.key_amount
			data.sustain_length = note.sustain_length
			data.must_press = gotta_hit
			data.type = note.type
			data.alt_anim = note.alt_anim
			unspawn_notes.append(data)
			
	unspawn_notes.sort_custom(func sorting(a, b): return a.strum_time < b.strum_time)
	Conductor.connect("beat_hit", func d(): beat_hit(Conductor.cur_beat))
	Conductor.connect("step_hit", func d(): step_hit(Conductor.cur_step))
	
	og_speed = opponent_strums.note_speed
	
func beat_hit(beat:int):
	if(inst.playing && !(Conductor.is_audio_synced(inst) || Conductor.is_audio_synced(voices))):
		Conductor.position = inst.get_playback_position() * 1000.0
		voices.seek(inst.get_playback_position())
	
func step_hit(step:int):
	pass

func _process(delta):
	Conductor.position += (delta * 1000.0) * Conductor.rate
	if Conductor.position >= 0 && starting_song: start_song() 
	
	if Input.is_action_just_pressed("skip_intro") && !skipped_intro:
		skipped_intro = true
		if unspawn_notes[0].strum_time >= 1000:
			start_song()
		Conductor.position = unspawn_notes[0].strum_time - 1000
		if unspawn_notes[0].strum_time >= 1000:
			inst.seek(Conductor.position / 1000.0)
			voices.seek(Conductor.position / 1000.0)
		
func start_song():
	starting_song = false
	Conductor.position = 0
	
	inst.play()
	voices.play()
	
	inst.seek(0.0)
	voices.seek(0.0)
	
func _physics_process(delta):
	for note in unspawn_notes:
		var strum_line:StrumLine = player_strums if note.must_press else opponent_strums
		var spawn_mult:float = (1500 / strum_line.note_speed) * Conductor.rate
		if note.strum_time <= Conductor.position + spawn_mult:
			skipped_intro = true
			
			var new_note:Note = load("res://scenes/game/notes/"+note.type+".tscn").instantiate()
			new_note.strum_time = note.strum_time
			new_note.direction = note.direction
			new_note.must_press = note.must_press
			new_note.position.x = strum_line.receptors.get_child(note.direction).position.x
			strum_line.notes.add_child(new_note)
			
			var length:int = floor(note.sustain_length / Conductor.step_crochet)
			for i in length:
				var sus_note:Note = load("res://scenes/game/notes/"+note.type+".tscn").instantiate()
				sus_note.strum_time = note.strum_time + (Conductor.step_crochet * i) + (Conductor.step_crochet / og_speed)
				sus_note.direction = note.direction
				sus_note.must_press = note.must_press
				sus_note.is_sustain = true
				sus_note.step_crochet = Conductor.step_crochet
				sus_note.parent = strum_line
				sus_note.position.x = strum_line.receptors.get_child(note.direction).position.x + (strum_line.sustains.size.x / 2)
				sus_note.modulate.a = 0.6
				if i >= length-1: sus_note.is_sustain_tail = true
				strum_line.sustains.add_child(sus_note)
				new_note.sustain_pieces.append(sus_note)
				
			unspawn_notes.erase(note)
		else:
			break
