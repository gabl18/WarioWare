extends TextureButton

@onready var parent = $".."
@onready var honk_sfx: AudioStreamPlayer = $"../HonkSFX"

func _on_pressed() -> void:
	honk_sfx.play()
	parent.buttons_pressed += 1
