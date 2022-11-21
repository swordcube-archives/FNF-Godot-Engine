extends CanvasLayer

@onready var rect:TextureRect = $Rect
@onready var anim:AnimationPlayer = $Rect/AnimationPlayer

func trans_in(callback:Callable):
	anim.seek(0.0)
	anim.play("in")
	var duration:float = anim.get_animation("in").length
	get_tree().create_timer(duration+0.05).connect("timeout", callback)
	
func trans_out(callback:Callable):
	trans_out_no_callback()
	var duration:float = anim.get_animation("out").length
	get_tree().create_timer(duration+0.05).connect("timeout", callback)
	
func trans_out_no_callback():
	anim.seek(0.0)
	anim.play("out")
