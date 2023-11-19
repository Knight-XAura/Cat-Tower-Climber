extends Control

var game: PackedScene = preload("res://world/world.tscn")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Retry"):
		add_sibling(game.instantiate())
		queue_free()
