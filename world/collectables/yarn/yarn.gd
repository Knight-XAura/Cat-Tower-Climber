extends Node3D

var points: int = 1


func _on_timer_timeout() -> void:
	queue_free()
