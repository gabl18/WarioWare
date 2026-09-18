extends Area2D

@export var speed = 400.0
var passed = false

func _process(delta: float) -> void:
	position.x -= speed * delta
	
	if position.x < -100:
		queue_free()
