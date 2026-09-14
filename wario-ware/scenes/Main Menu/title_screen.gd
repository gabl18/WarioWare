extends Node2D

# Start
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Every Level Used/level_scene.tscn")


# Settings
func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main Menu/settings_screen.tscn")

# Quit
func _on_quit_pressed() -> void:
	get_tree().quit()
