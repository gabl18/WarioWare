extends Node2D

@onready var themed_timer: Node2D = $ThemedTimer

var buttons_pressed := 0
var timer_end = false
# honking - press a button to honk at the humans

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await themed_timer.Timer(4.0)
	timer_end = true 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if buttons_pressed == 18:
		if Global.minigames_done >= 3:
			get_tree().change_scene_to_file("res://scenes/done_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://level_scene.tscn")
	
	if timer_end:
		Global.lives -= 1
		Global.minigames_done -=1
		get_tree().change_scene_to_file("res://level_scene.tscn")
