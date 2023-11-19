extends Node3D


func _on_game_over_screen_restart() -> void:
	add_sibling(load("res://world/world.tscn").instantiate())
	queue_free()
