extends Node2D

@onready var themed_timer: Node2D = $ThemedTimer
@onready var intro_text: Node2D = $IntroText
var rand_score = 4.0
var rng = RandomNumberGenerator.new()

var buttons_pressed := 0
var timer_end = false
var task_text = "DONT CLICK!"
# honking - press a button to honk at the humans

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rand_score = rng.randf_range(2.0, 10.0)
	get_tree().paused=true
	await intro_text.textDisplay(2.0, task_text)
	get_tree().paused=false
	await themed_timer.Timer(rand_score)
	timer_end = true 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if buttons_pressed >= 1:
		Global.lives -= 1
		Global.minigames_done -=1
		get_tree().change_scene_to_file("res://scenes/Every Level Used/level_scene.tscn")
	
	if timer_end:
		if Global.minigames_done >= Global.minigames_needed:
			get_tree().change_scene_to_file("res://scenes/Finish Screen/done_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/Every Level Used/level_scene.tscn")
