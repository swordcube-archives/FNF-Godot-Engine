extends CanvasLayer

@onready var label:Label = $Label

func _ready():
	update_text()
	$UpdateTimer.connect("timeout", func baller(): update_text())

func update_text():
	label.text = "FPS: "+str(Engine.get_frames_per_second())
	if OS.is_debug_build():
		label.text += "\nMEM: "+CoolUtil.bytes_to_human(CoolUtil.get_mem_usage())+" / "+CoolUtil.bytes_to_human(CoolUtil.get_mem_peak())
	label.text += "\nVRAM: "+CoolUtil.bytes_to_human(CoolUtil.get_vram_usage())+" / "+CoolUtil.bytes_to_human(CoolUtil.get_vram_peak())
