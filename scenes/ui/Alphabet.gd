@tool
extends ReferenceRect

class_name Alphabet

@icon("res://editor/icons/alphabet.png")

# i would make this a bitmap font
# but i don't feel like doing that rn lmao

enum AlphabetAlign {
	LEFT,
	CENTER,
	RIGHT
}

var cool:Array[float] = []
var piss:Array[Array] = []

var width:float = 0.0
var height:float = 0.0

var old_text:String = ""
var old_bold:bool = true
@export var bold:bool = true
@export_multiline var text:String = ""

var old_alignment:AlphabetAlign = AlphabetAlign.LEFT
@export var alignment:AlphabetAlign = AlphabetAlign.LEFT

var changing:bool = false

var is_menu_item:bool = false
var target_y:int = 0
var y_mult:float = 120
var x_add:float = 0
var y_add:float = 0

var force_x:int

var bold_letters:PackedStringArray = "#$%'\\,-\"!/*.?[]^_|~abcdefghijklmnopqrstuvwxyz".split("")
var regular_letters:PackedStringArray = "#$%'\\,-\"!/*.?[]^_|~ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".split("")

func _ready():
	update_text()

func _process(delta):
	if is_menu_item:
		var scaled_y = remap(target_y, 0, 1, 0, 1.3);

		var lerp_val:float = clamp(delta * 60 * 0.16, 0, 1);
		position.y = lerp(position.y, (scaled_y * y_mult) + (720 * 0.48) + y_add, lerp_val)
		if force_x:
			position.x = force_x
		else:
			position.x = lerp(position.x, (target_y * 20) + 90 + x_add, lerp_val)
			
	if old_bold != bold:
		old_bold = bold
		old_text = ""
				
	if old_text != text:
		changing = true
		old_text = text
		update_text()
		
func update_text():
	cool = []
	piss = []
	
	var letters_node:Node2D = $Letters
	if !letters_node: return
	
	for child in letters_node.get_children():
		child.queue_free()
		
	var x_pos:float = 0.0
	var y_pos:float = 0.0
	var template:AnimatedSprite2D = $BoldTemplate if bold else $DefaultTemplate
	var split = text.split("\n")
	for line in split:
		piss.append([])
		
		for i in range(line.length()):
			if line[i] == " ":
				x_pos += 25
				continue
				
			if (bold && !bold_letters.has(line[i].to_lower())) || (!bold && !regular_letters.has(line[i])): continue
				
			var letter:AnimatedSprite2D = template.duplicate()
			letter.position.x = x_pos
			letter.position.y = y_pos
			
			var anim:String = line[i].to_upper() if bold else line[i].to_lower()
			if bold:
				match anim:
					"?":
						anim = "-question mark-"
						letter.position.y -= 10
					"!":
						anim = "-exclamation point-"
						letter.position.y -= 10
					"'":
						anim = "-apostraphie-"
						letter.position.y -= 5
					"\"":
						anim = "-end quote-"
						letter.position.y -= 5
					"-":
						anim = "-dash-"
						letter.position.y += 20
					"*":
						anim = "-multiply x-"
						letter.position.y += 20
					".":
						anim = "-period-"
						letter.position.y += 40
					",":
						anim = "-comma-"
						letter.position.y += 40
					"~":
						letter.position.y += 20
					"\\":
						anim = "-back slash-"
					"/":
						anim = "-forward slash-"
			else:
				match anim:
					"'":
						anim = "-apostraphie-";
					"\\":
						anim = "-back slash-";
					"/":
						anim = "-forward slash-";
					"\"":
						anim = "-end quote-";
					"?":
						anim = "-question mark-";
					"!":
						anim = "-exclamation point-";
					".":
						anim = "-period-";
						letter.position.y += 42;
					",":
						anim = "-comma-";
						letter.position.y += 42;
					"-":
						anim = "-dash-";
						letter.position.y += 14
					"←":
						anim = "-left arrow-";
						letter.position.y += 5
					"↓":
						anim = "-down arrow-";
						letter.position.y += 5
					"↑":
						anim = "-up arrow-";
						letter.position.y += 5
					"→":
						anim = "-right arrow-";
						letter.position.y += 5

					# letter offsets
					"a":
						letter.position.y += 30
					"b", "f":
						letter.position.y += 17
					"c":
						letter.position.y += 30
					"d":
						letter.position.y += 15
					"h":
						letter.position.y += 20
					"t", "i", "j", "k", "l":
						letter.position.y += 25
					"e", "g":
						letter.position.y += 32.5
					"m":
						letter.position.y += 33.5
					"n", "o", "p", "q", "r", "s", "u", "v", "w", "x", "y", "z":
						letter.position.y += 35

					# Symbol Offsets
					":", ";", "*":
						letter.position.y += 10
						
					# number offsets
					"0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
						letter.position.y += 10
					
			letter.play(anim)
			letter.visible = true
			letters_node.add_child(letter)
			var bruh = letter.frames.get_frame(letter.animation, 0)
			x_pos += bruh.get_width()
			piss[piss.size()-1].append(bruh.get_width())
		
		cool.append(x_pos)
		y_pos += 60
		x_pos = 0
		
	var rect_size:float = 0.0
	for size in cool:
		if size > rect_size:
			rect_size = size
	width = rect_size
	height = y_pos + 10
	custom_minimum_size = Vector2(rect_size, y_pos + 10)	
	size.x = rect_size
	size.y = y_pos + 10
	changing = false
	
	on_update_text()
	
func on_update_text():
	pass
		
func screen_center(axes:String = "XY"):
	match axes.to_upper():
		"X":
			position.x = 640 - (width / 2.0)
		"Y":
			position.y = 360 - (height / 2.0)
		_:
			position = Vector2(
				640 - (width / 2.0),
				360 - (height / 2.0)
			)
