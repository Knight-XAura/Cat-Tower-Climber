extends Node3D


func _on_game_over_screen_restart() -> void:
	get_tree().reload_current_scene()
