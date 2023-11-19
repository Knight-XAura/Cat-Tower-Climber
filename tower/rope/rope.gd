extends StaticBody3D

@onready var timer: Timer = $Timer

func _on_area_3d_2_body_exited(body: Node3D) -> void:
	timer.start()


func _on_timer_timeout() -> void:
	queue_free()
