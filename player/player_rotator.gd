extends Node3D


func _on_cat_rotate_parent_node(direction) -> void:
	rotate_y(deg_to_rad(90 * direction))
	$Cat.position.x = -4.25 * direction
