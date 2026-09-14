extends Node2D

# Start
func _on_menu_pressed() -> void:
	Global.lives = 5
	Global.minigames_done = 0
	get_tree().change_scene_to_file("res://title_screen.tscn")

# Quit
func _on_quit_pressed() -> void:
	get_tree().quit()
