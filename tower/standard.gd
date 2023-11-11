extends StaticBody3D

@onready var timer: Timer = $Timer


func _on_detector_body_exited(body: Node3D) -> void:
	timer.start()


func _on_timer_timeout() -> void:
	queue_free()
