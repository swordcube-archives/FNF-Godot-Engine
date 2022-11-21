extends Node

# I remade FlxTimer in Godot fuck you

class_name EasyTimer

var infinite:bool = false
var loops_left:int = 0

func start(duration:float, callback:Callable, loops:int = 1):
	loops_left = loops
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = false
	infinite = loops < 1
	timer.connect("timeout", 
		func timeout():
			if infinite:
				callback.call(self)
			else:
				loops_left -= 1
				callback.call(self)
				if loops_left < 1:
					Audio.remove_child(timer)
					timer.stop()
					timer.queue_free()
	)
	Audio.add_child(timer)
	timer.start()
	return self
