extends TextureButton

@onready var parent = $".."

func _on_pressed() -> void:
	parent.buttons_pressed += 1
