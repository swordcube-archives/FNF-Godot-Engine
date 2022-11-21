extends AudioStreamPlayer

class_name AudioClone

func _ready():
	connect("finished", func a(): queue_free())
