extends Node2D

@onready var pointer: ColorRect = $Pointer
@onready var target_zone: ColorRect = $TargetZone
@onready var honk_sound: AudioStreamPlayer = $HonkSound
@onready var fail_sound: AudioStreamPlayer = $FailSound
@onready var themed_timer: Node2D = $ThemedTimer
@onready var intro_text: Node2D = $IntroText

@onready var goose_sprite: Sprite2D = $GooseSprite

@export var normal_texture = load("res://images/minigame6/rythmhonk1.png")
@export var success_texture = load("res://images/minigame6/rythmhonk2.png")
@export var fail_texture = load("res://images/minigame6/rythmhonk3.png")

@export var pointer_speed = 600.0
@export var tolerance_pixels = 30.0

@export var wiggle_speed = 10.0
@export var wiggle_angle = 10.0
var wiggle_time = 0.0

var rng = RandomNumberGenerator.new()

var timer_end = false
var task_text = "HONK CORRECTLY!"
var move_direction = 1
var min_x = 190.0
var max_x = 780.0
var has_honked = false

func _ready():
	pointer.position.x = min_x
	target_zone.position.x = randf_range(250.0, 710.0)
	
	if normal_texture:
		goose_sprite.texture = normal_texture
		
	get_tree().paused=true
	await intro_text.textDisplay(2.0, task_text)
	get_tree().paused=false
	await themed_timer.Timer(6.0)
	timer_end = true 

func _process(delta):
	if not has_honked:
		wiggle_time += delta * wiggle_speed
		goose_sprite.rotation_degrees = sin(wiggle_time) * wiggle_angle
		
	pointer.position.x += pointer_speed * move_direction * delta
	
	if pointer.position.x >= max_x:
		pointer.position.x = max_x
		move_direction = -1
	elif pointer.position.x <= min_x:
		pointer.position.x = min_x
		move_direction = 1
		
	if timer_end and not has_honked:
		fail_game()
		
func _unhandled_input(event: InputEvent) -> void:
	if has_honked:
		return
		
	if event.is_action_pressed("ui_accept"):
		has_honked = true
		check_honk_timing()
		
func check_honk_timing():
	var pointer_rect = Rect2(pointer.global_position, pointer.size)
	var target_rect = Rect2(target_zone.global_position, target_zone.size)
	
	var is_hit = pointer_rect.intersects(target_rect)
		
	if is_hit:
		if success_texture:
			goose_sprite.texture = success_texture
		goose_sprite.rotation_degrees = 0
		
		honk_sound.play()
		await honk_sound.finished
		
		if Global.minigames_done >= Global.minigames_needed:
			get_tree().change_scene_to_file("res://scenes/Finish Screen/done_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://scenes/Every Level Used/level_scene.tscn")
	else:
		fail_game()
	
func fail_game():
	has_honked = true
	
	if fail_texture: 
		goose_sprite.texture = fail_texture
	goose_sprite.rotation_degrees = 0
	
	fail_sound.play()
	await fail_sound.finished
	
	Global.lives -= 1
	Global.minigames_done -= 1
	get_tree().change_scene_to_file("res://scenes/Every Level Used/level_scene.tscn")
