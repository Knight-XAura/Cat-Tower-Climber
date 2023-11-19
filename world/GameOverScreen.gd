extends Control

signal restart

func _input(event: InputEvent) -> void:
	if visible:
		if Input.is_action_just_pressed("Retry"):
			restart.emit()
