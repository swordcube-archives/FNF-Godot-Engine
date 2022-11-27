extends Node2D

class_name Note

@onready var PlayState:PlayState = $"../../../../"
@onready var sprite:AnimatedSprite2D = $Sprite
@export var should_hit:bool = true
@export var strum_time:float = 0.0
@export var direction:int = 0

var parent:StrumLine
var step_crochet:float = 0.0
var is_sustain:bool = false
var is_sustain_tail:bool = false
var was_good_hit:bool = false
var too_late:bool = false
var can_be_hit:bool = true
var must_press:bool = true

var sustain_pieces:Array[Note] = []

func _ready():
	var direction_list:Array[String] = [
		"left",
		"down",
		"up",
		"right"
	]
	var anim_name:String = direction_list[direction]
	if is_sustain && !is_sustain_tail: anim_name += " hold"
	if is_sustain && is_sustain_tail: 
		anim_name += " tail"
		sprite.flip_v = Settings.grab("downscroll")
		
	sprite.play(anim_name)
	
	if is_sustain:
		sprite.centered = false
		
		var frame_width = sprite.frames.get_frame(sprite.animation, sprite.frame).get_width()
		sprite.offset.x -= (sprite.scale.x * frame_width) / 1.4

# OVERRIDE THESE TO DO CUSTOM SHIT WHEN NOTES
# ARE HIT OR MISSED!
func opponent_hit():
	pass
	
func player_hit():
	pass
	
func opponent_miss():
	pass
	
func player_miss():
	pass

# DON'T TOUCH!! UNLESS YOU ACTUALLY LIKE NEED TO LMAO!
func _process(delta):
	if is_sustain && !is_sustain_tail:
		sprite.scale.y = 0.7 * ((step_crochet / 100 * 1.5) * (parent.note_speed / Conductor.rate))
		
	if was_good_hit && !parent.sustains.clip_contents:
		visible = false
	else:
		visible = true
		
	if must_press:
		var hit_mults:Array[float] = [1.0, 1.5] if should_hit else [0.5, 0.5]
		if strum_time > Conductor.position - Conductor.safe_zone_offset * hit_mults[0] && strum_time < Conductor.position + Conductor.safe_zone_offset * hit_mults[1]:
			can_be_hit = true
		else:
			can_be_hit = false

		if strum_time < Conductor.position - Conductor.safe_zone_offset && !was_good_hit && !too_late:
			too_late = true
			PlayState.voices.volume_db = -9999
	else:
		can_be_hit = false
		
	if too_late: modulate.a = 0.3
