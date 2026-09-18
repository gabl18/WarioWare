extends TextureButton

@onready var parent = $".."
@onready var fail_sfx: AudioStreamPlayer = $"../FailSFX"

const normal1 = preload("res://images/minigame5/dont_touch1.png")
const normal2 = preload("res://images/minigame5/dont_touch2.png")
const normal3 = preload("res://images/minigame5/dont_touch3.png")
const creepy1 = preload("res://images/minigame5/dont_touch4.png")
const creepy2 = preload("res://images/minigame5/dont_touch5.png")
const creepy3 = preload("res://images/minigame5/dont_touch6.png")
const honk = preload("res://images/minigame5/dont_touch7.png")

@onready var frames = [normal1, normal2, normal3]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_animation()



func start_animation():
	var frame = 0
	while true:
		if texture_normal == honk:
			break
		else:
			texture_normal = frames[frame]
			
			await get_tree().create_timer(1.0).timeout
			frame = (frame +1) % frames.size()
			
func _on_pressed() -> void:
	texture_pressed = honk
	texture_normal = honk
	fail_sfx.play()
	await fail_sfx.finished
	parent.buttons_pressed += 1
