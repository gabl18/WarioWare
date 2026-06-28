extends TextureRect

const normal_texture = preload("res://images/minigame3/Minigame5.png")
const annoyed_texture = preload("res://images/minigame3/Minigame6.png")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	if texture == normal_texture:
		texture = annoyed_texture
	else:
		texture = normal_texture
