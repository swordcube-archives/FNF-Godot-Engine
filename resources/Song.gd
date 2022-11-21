extends Resource

class_name Song

var name:String = "Test"
var sections:Array[Section] = []
var events:Array[EventGroup] = []
var bpm:float = 150.0
var needs_voices:bool = true
var scroll_speed:float = 1.5

var key_amount:int = 4

var bf:String = "bf"
var gf:String = "gf"
var dad:String = "bf-pixel"
var stage:String = "default"
