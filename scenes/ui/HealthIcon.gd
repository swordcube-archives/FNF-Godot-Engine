@tool
extends Node2D

class_name HealthIcon
@icon("res://editor/icons/healthicon.png")

@export var icon_amount:int = 3
@export var icon:String = "bf"

var old_amount:int = 0
var old_icon:String = ""

var health:float = 50.0

func update_icon():
	var path:String = "res://assets/images/icons/"+icon+".png"
	if !ResourceLoader.exists(path):
		path = "res://assets/images/icons/face.png"
	$Sprite.texture = load(path)

func _process(delta):
	if old_icon != icon:
		old_icon = icon
		update_icon()
		
	if old_amount != icon_amount:
		old_amount = icon_amount
		$Sprite.hframes = icon_amount

func get_icon_index(health:float, icons:int):
	match icons:
		1:
			return 0
		2:
			if health < 20: return 1
			return 0
		3:
			if health < 20: return 1
			if health > 80: return 2
			return 0
		_:
			for i in icons:
				if health > (100.0 / icons) * (i+1): continue

				# finds the first icon we are less or equal to, then choose it
				if i == 0: return 1
				if i == 1: return 0
				return i
