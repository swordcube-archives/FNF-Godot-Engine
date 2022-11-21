extends Node2D

class_name StrumLine

@export var is_opponent:bool = false
@export var note_speed:float = 3.2

@onready var receptors:Node2D = $Receptors
@onready var notes:Node2D = $Notes
@onready var sustains:ColorRect = $Sustains

func _ready():
	if Settings.grab("downscroll"):
		sustains.position.y -= sustains.size.y
		
	for i in receptors.get_child_count():
		pressed.append(false)
		
	if !is_opponent: return
	
	sustains.clip_contents = true
	var children2 = receptors.get_children()
	for i in children2.size():
		var receptor = children2[i]
		receptor.connect("animation_finished", func balls():
			if "confirm" in receptor.animation:
				receptor.frame = 0
				receptor.play_anim("static")
		)
		
var pressed:Array[bool] = []

func _input(event):
	if is_opponent: return
	
	pressed = []
	for i in receptors.get_child_count():
		pressed.append(Input.is_action_pressed("game_"+str(i)))
	
	var children = receptors.get_children()
	for i in children.size():
		if Input.is_action_just_pressed("game_"+str(i)):
			var receptor = children[i]
			receptor.frame = 0
			receptor.play_anim("press")
			sustains.clip_contents = true
			
		if Input.is_action_just_released("game_"+str(i)):
			var receptor = children[i]
			receptor.frame = 0
			receptor.play_anim("static")
			sustains.clip_contents = false
			
	var dont_hit:Array[bool] = []
	for i in receptors.get_child_count(): 
		dont_hit.append(false)
		
	var children2 = notes.get_children()
	children2.sort_custom(func n(a, b): return a.strum_time < b.strum_time)
	for i in children2.size():
		var note:Note = children2[i]
		if !dont_hit[note.direction] && !note.is_sustain && note.can_be_hit && !note.too_late && !note.was_good_hit:
			if Input.is_action_just_pressed("game_"+str(note.direction)):
				dont_hit[note.direction] = true
				var receptor = children[note.direction]
				receptor.frame = 0
				receptor.play_anim("confirm")
				sustains.clip_contents = true
				
				pop_up_score(note, Ranking.judge_note(note.strum_time))
				
				# WE HATE STACKED NOTEs!!
				for a in children2.size():
					var stacked_note:Note = children2[a]
					if stacked_note != note && stacked_note.direction == note.direction && stacked_note.strum_time - note.strum_time <= 5.0:
						stacked_note.queue_free()
					else:
						continue
				
				note.player_hit()
				note.queue_free()
				
func pop_up_score(note:Note, judgement:String):
	var receptor = receptors.get_children()[note.direction]
	var judge_data = Ranking.judgements[judgement]
	
	if judge_data.noteSplash:
		receptor.do_splash()
			
func _process(delta):
	var children = notes.get_children()
	for i in children.size():
		var note:Note = children[i]
		note.position.y = (0.45 if Settings.grab("downscroll") else -0.45) * (Conductor.position - note.strum_time) * (note_speed / Conductor.rate)
		if !note.must_press && note.strum_time <= Conductor.position:
			var receptor = receptors.get_child(note.direction)
			receptor.frame = 0
			receptor.play_anim("confirm")
			note.opponent_hit()
			note.queue_free()
			
		if note.must_press && note.strum_time < Conductor.position - (Conductor.safe_zone_offset):
			for child in note.sustain_pieces:
				if !is_instance_valid(child): continue
				child.too_late = true
				
			sustains.clip_contents = false
			if pressed[note.direction]:
				var receptor = receptors.get_child(note.direction)
				receptor.frame = 0
				receptor.play_anim("press")
				note.queue_free()
			
	var fake_crochet:float = (60.0 / Global.SONG.bpm) * 1000.0
	var fake_bpm:float = Global.SONG.bpm / Conductor.rate
	var children2 = sustains.get_children()
	for i in children2.size():
		var note:Note = children2[i]
		var spawn_mult:float = (1500 / note.parent.note_speed) * Conductor.rate
		if note.strum_time <= Conductor.position + spawn_mult:
			note.visible = true
			note.position.y = (0.45 if Settings.grab("downscroll") else -0.45) * (Conductor.position - note.strum_time) * (note_speed / Conductor.rate)
			if Settings.grab("downscroll"):
				note.position.y += sustains.size.y
			
			"""
			if(PlayerSettings.prefs.get("Downscroll") && noteSpeed == Math.abs(noteSpeed) && note.isSustainNote) {
				if (note.isSustainTail) {
					note.y += 10.5 * (fakeCrochet / 400) * 1.5 * noteSpeed + (46 * (noteSpeed - 1));
					note.y -= 46 * (1 - (fakeCrochet / 600)) * noteSpeed;
					if(note.skinJSON.isPixel)
						note.y += 8 + (6 - note.ogHeight) * 6;
				}
				note.y += (Note.spacing / 2) - (60.5 * (noteSpeed - 1));
				note.y += 27.5 * ((PlayState.SONG.bpm / 100) - 1) * (noteSpeed - 1);
			}
			"""
			var adjusted_speed:float = note_speed / Conductor.rate
			if Settings.grab("downscroll") && adjusted_speed == abs(adjusted_speed):
				if note.is_sustain_tail:
					note.position.y += 10.5 * (fake_crochet / 400.0) * 1.5 * adjusted_speed + (46.0 * (adjusted_speed - 1.0))
					note.position.y -= 46.0 * (1.0 - (fake_crochet / 600.0)) * adjusted_speed
					# TODO: FIX FOR PIXEL SKINS
					# note.position.y -= 2
					
				note.position.y -= (fake_crochet / 15.0) * adjusted_speed
			else:
				note.position.y -= (fake_crochet / 15.0) * adjusted_speed
			
			if !note.was_good_hit && !note.must_press && note.strum_time <= Conductor.position:
				var receptor = receptors.get_child(note.direction)
				receptor.frame = 0
				receptor.play_anim("confirm")
				note.was_good_hit = true
				note.opponent_hit()
				
			if !note.was_good_hit && note.must_press && note.strum_time <= Conductor.position && pressed[note.direction] && note.can_be_hit && !note.too_late:
				var receptor = receptors.get_child(note.direction)
				receptor.frame = 0
				receptor.play_anim("confirm")
				sustains.clip_contents = true
				note.was_good_hit = true
				note.player_hit()
			
			if note.strum_time < Conductor.position - 350:
				note.queue_free()
		else:
			note.visible = false
			continue
