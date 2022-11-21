extends AnimatedSprite2D

@onready var splash = $splash
@export var direction:String = "left"

func _ready():
	play_anim("")
	
func _process(delta):
	speed_scale = Conductor.rate
	
func play_anim(a:String):
	match a:
		"confirm":
			play(direction+" confirm")
		"press":
			play(direction+" press")
		_:
			play(direction+" static")
			
func do_splash():
	splash.frame = 0
	splash.play("note impact "+str(randi_range(1, 2))+" "+direction)
	splash.visible = true
	splash.speed_scale = 1 + randf_range(-0.25, 0.25)

func _on_splash_animation_finished():
	splash.visible = false
