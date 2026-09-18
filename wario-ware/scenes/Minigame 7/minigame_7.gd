extends Node2D

@onready var goose_sprite: Sprite2D = $Sprite2D
@onready var goose_hitbox: Area2D = $Area2D
@onready var obstacle_container: Node2D = $ObstacleContainer

@onready var honk_sound: AudioStreamPlayer = $HonkSound
@onready var fail_sound: AudioStreamPlayer = $FailSound
@onready var themed_timer: Node2D = $ThemedTimer
@onready var intro_text: Node2D = $IntroText

@export var run_frame1= preload("res://images/minigame7/running_goose1.png")
@export var run_frame2= preload("res://images/minigame7/running_goose2.png")

@export var prop_textures = [
	preload("res://images/minigame7/minigame7assets1.png"),
	preload("res://images/minigame7/minigame7assets2.png"),
	preload("res://images/minigame7/minigame7assets3.png")
]

@export var obstacle_scene = preload("res://scenes/Minigame 7/Obstacle.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
