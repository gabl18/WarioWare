extends Node2D

# Start
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://level_scene.tscn")


# Settings
func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://settings_screen.tscn")

# Quit
func _on_quit_pressed() -> void:
	get_tree().quit()
