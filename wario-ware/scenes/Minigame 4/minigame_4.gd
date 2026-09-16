extends Node

@export var chimney_scene : PackedScene
@onready var intro_text: Node2D = $IntroText

var task_text = "ACHIEVE " + str(rand_score) + " POINTS!"
var game_running : bool
var game_over : bool
var scroll
var score
var rand_score : int = 5
const SCROLL_SPEED : float = 300
var screen_size : Vector2i
var ground_height : int
var chimneys : Array

var rng = RandomNumberGenerator.new()

const CHIMNEY_DELAY : int = 150
const CHIMNEY_RANGE : int = 170


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	ground_height = $ScrollignBackground2/Ground.get_node("Sprite2D").texture.get_height()
	new_game()
	get_tree().paused=true
	await intro_text.textDisplay(2.0, task_text)
	get_tree().paused=false

func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	rand_score = rng.randi_range(3, 10)
	$ScoreLabel.text = "SCORE: " + str(score)
	task_text = "ACHIEVE " + str(rand_score) + " POINTS!"
	chimneys.clear()
	generate_chimneys()
	$Bird.reset()

func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				else:
					if $Bird.flying:
						$Bird.flap()
						check_top()

func start_game():
	game_running = true
	$Bird.flying = true
	$Bird.flap()
	$ChimneyTimer.wait_time = 2.0
	$ChimneyTimer.start()

func _process(delta: float):
	if game_running:
		scroll += SCROLL_SPEED * delta
		if scroll >= screen_size.x:
			scroll = 0
		
		for chimney in chimneys:
			chimney.position.x -= SCROLL_SPEED * delta
	
	if score == rand_score:
		if Global.minigames_done >= Global.minigames_needed:
			get_tree().change_scene_to_file("res://scenes/Finish Screen/done_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/Every Level Used/level_scene.tscn")

func _on_chimney_timer_timeout() -> void:
	generate_chimneys()
	
func generate_chimneys():
	var viewport_size = get_viewport().get_visible_rect().size
	var chimney = chimney_scene.instantiate()
	
	chimney.position.x = screen_size.x + CHIMNEY_DELAY
	
	var playable_height = viewport_size.y - ground_height
	chimney.position.y = (playable_height / 2.0) + randi_range(-CHIMNEY_RANGE, CHIMNEY_RANGE)
	
	chimney.hit.connect(bird_hit)
	chimney.scored.connect(scored)
	add_child(chimney)
	chimneys.append(chimney)

func scored():
	score += 1
	$ScoreLabel.text = "SCORE: " + str(score)
	
func check_top():
	if $Bird.position.y < 0:
		$Bird.falling = true
		stop_game()
		
func stop_game():
	$ChimneyTimer.stop()
	$Bird.flying = false
	game_running = false
	game_over = true
	await get_tree().create_timer(1.5).timeout
	Global.lives -= 1
	Global.minigames_done -=1
	get_tree().change_scene_to_file("res://scenes/Every Level Used/level_scene.tscn")

func bird_hit():
	$Bird.falling = true
	stop_game()

func _on_ground_hit() -> void:
	$Bird.falling = false
	stop_game()
