extends Node3D

@export var tower_standard: PackedScene
var meters: int = 0


func _on_tower_timer_timeout() -> void:
	meters += 9
	var spawn_tower = tower_standard.instantiate()
	spawn_tower.position.y += meters
	add_child(spawn_tower)
