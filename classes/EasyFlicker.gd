extends Node

class_name EasyFlicker

signal finished

var object:Node2D
var duration:float
var interval:float
var end_visibility:bool
var timer:EasyTimer

func start(object:Node2D, duration:float, interval:float, end_visibility:bool):
	self.object = object
	self.duration = duration
	self.interval = interval
	self.end_visibility = end_visibility
	timer = EasyTimer.new().start(interval, func(tmr:EasyTimer):
		object.visible = !object.visible
	, int(duration / interval))
	timer.connect("finished", func():
		if timer.loops > 0:
			object.visible = end_visibility
			finished.emit()
			queue_free()
	)
	return self
