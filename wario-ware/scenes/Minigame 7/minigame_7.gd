extends Node2D

@onready var goose_sprite: Sprite2D = $Sprite2D
@onready var goose_hitbox: Area2D = $Area2D
@onready var obstacle_container: Node2D = $ObstacleContainer

@onready var honk_sound: AudioStreamPlayer = $HonkSound
@onready var fail_sound: AudioStreamPlayer = $FailSound
@onready var themed_timer: Node2D = $ThemedTimer
@onready var intro_text: Node2D = $IntroText

@export var run_frame_1= preload("res://images/minigame7/running_goose1.png")
@export var run_frame_2= preload("res://images/minigame7/running_goose2.png")

@export var prop_textures = [
	preload("res://images/minigame7/minigame7assets1.png"),
	preload("res://images/minigame7/minigame7assets2.png"),
	preload("res://images/minigame7/minigame7assets3.png")
]

@export var obstacle_scene = preload("res://scenes/Minigame 7/Obstacle.tscn")

@export var gravity = 1200.0
@export var jump_force = -600.0

var task_text = "JUMP 2 TIMES!"
var goose_ground = 0.0
var goose_velocity_y = 0.0
var is_on_ground = true
var timer_end = false

var anim_timer = 0.0
var use_first_frame = true

var target_score = 2
var current_score = 0
var has_finished = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goose_ground = goose_sprite.position.y
	target_score = randi_range(2, 4)
	task_text = "JUMP " + str(target_score) + " TIMES!"
	
	goose_hitbox.area_entered.connect(_on_obstacel_hit)
	
	get_tree().paused=true
	await intro_text.textDisplay(2.0, task_text)
	get_tree().paused=false
	
	spawn_next_obstacle()
	await themed_timer.Timer(10.0)
	timer_end = true 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_on_ground:
		anim_timer += delta
		if anim_timer >= 0.15:
			anim_timer = 0.0
			use_first_frame = not use_first_frame
			goose_sprite.texture = run_frame_1 if use_first_frame else run_frame_2
	
	if not is_on_ground:
		goose_velocity_y += gravity * delta
		goose_sprite.position.y += goose_velocity_y * delta
		goose_hitbox.position.y = goose_sprite.position.y
		
		if goose_sprite.position.y >= goose_ground:
			goose_sprite.position.y = goose_ground
			goose_hitbox.position.y = goose_ground
			is_on_ground = true
			goose_velocity_y = 0.0
	
	for obstacle in obstacle_container.get_children():
		if obstacle.position.x < goose_sprite.position.x and not obstacle.passed:
			obstacle.passed = true
			add_score()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and is_on_ground:
		is_on_ground = false
		goose_velocity_y = jump_force
		
func spawn_next_obstacle():
	var obs = obstacle_scene.instantiate()
	var obs_sprite = obs.get_node("Sprite2D") as Sprite2D
	obs_sprite.texture = prop_textures.pick_random()
	
	var obs_collision = obs.get_node("CollisionShape2D") as CollisionShape2D
	var rect_shape = RectangleShape2D.new()
	rect_shape.size = obs_sprite.texture.get_size()
	obs_collision.shape = rect_shape
	
	obs.position = Vector2(1000, goose_ground)
	obstacle_container.add_child(obs)
	
	var random_delay = randf_range(2.0, 2.8)
	get_tree().create_timer(random_delay).timeout.connect(spawn_next_obstacle)
	
func _on_obstacel_hit(_area):
	if not has_finished:
		fail_game()

func add_score():
	current_score += 1
	if current_score >= target_score and not has_finished:
		win_game()

func win_game():
	has_finished = true
	honk_sound.play()
	await honk_sound.finished
	
	if Global.minigames_done >= Global.minigames_needed:
		get_tree().change_scene_to_file("res://scenes/Finish Screen/done_screen.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/Every Level Used/level_scene.tscn")
			
func fail_game():
	has_finished = true
	fail_sound.play()
	await fail_sound.finished
	
	Global.lives -= 1
	Global.minigames_done -= 1
	get_tree().change_scene_to_file("res://scenes/Every Level Used/level_scene.tscn")
