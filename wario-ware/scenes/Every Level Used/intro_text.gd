extends Node2D

@onready var text_label: Label = $text

var time : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func textDisplay(start_time, task_text): # making a new function for timer countdown!
	# we want the timer to go down, and when it reaches 0 it transitions 
	# to the next scene!
	text_label.text = task_text
	time = start_time
	
	while time > 0.0: # run if timer hasnt reached 0
		await wait(0.10)
		time = time - 0.10
	
	#when timer reaches 0
	self.hide()
	return
	
func wait(seconds: float) -> void: # write this simple function out for wait!
	await get_tree().create_timer(seconds).timeout # makes u wait
