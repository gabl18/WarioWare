extends Node2D

@onready var themed_timer: Node2D = $ThemedTimer
@onready var intro_text: Node2D = $IntroText

var rand_score = 18
var rng = RandomNumberGenerator.new()

var buttons_pressed := 0
var timer_end = false
var task_text = "ANNOY THE HUMAN!"
# honking - press a button to honk at the humans

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rand_score = rng.randi_range(13, 25)
	get_tree().paused=true
	await intro_text.textDisplay(2.0, task_text)
	get_tree().paused=false
	await themed_timer.Timer(4.0)
	timer_end = true 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if buttons_pressed == rand_score:
		if Global.minigames_done >= Global.minigames_needed:
			get_tree().change_scene_to_file("res://scenes/Finish Screen/done_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/Every Level Used/level_scene.tscn")
	
	if timer_end:
		Global.lives -= 1
		Global.minigames_done -=1
		get_tree().change_scene_to_file("res://scenes/Every Level Used/level_scene.tscn")
