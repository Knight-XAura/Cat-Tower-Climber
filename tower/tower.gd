extends Node3D


@export_group("Tower Pieces", "tower")
@export var tower_standard: PackedScene

@export_group("Obstacle Pieces", "obstacle")
@export var obstacle_hole: PackedScene
@export var obstacle_rope: PackedScene

var obstacle_chance: Array[String] = []
@export_range(0.1, 25.0) var rope_chance: float = 10.0

@export_group("Collectables", "collectable")
@export var collectable_yarn: PackedScene
@export var collectable_catnip: PackedScene

var collectable_chance: Array[String] = []

var meters: int = 4.5

@onready var obstacle_timer: Timer = $"../Timers/ObstacleTimer"
@onready var collectable_timer: Timer = $"../Timers/CollectableTimer"


@export_range(0.1, 25.0) var catnip_chance: float = 5.0

var next_tower_piece_obstacle: bool = false

var initial_standard_tower_count: int = 8

func _ready() -> void:
	for chance in catnip_chance:
		collectable_chance.append("Catnip")
	for chance in 100 - catnip_chance:
		collectable_chance.append("Yarn")
	for chance in rope_chance:
		obstacle_chance.append("Rope")
	for chance in 100 - rope_chance:
		obstacle_chance.append("Hole")

func _on_tower_timer_timeout() -> void:
	if initial_standard_tower_count != 0:
		initial_standard_tower_count -= 1
	var spawn_tower = obstacle_rope.instantiate() if next_tower_piece_obstacle == true and initial_standard_tower_count == 0 else tower_standard.instantiate()
	spawn_tower.position.y = meters
	if next_tower_piece_obstacle == true and initial_standard_tower_count == 0:
		next_tower_piece_obstacle = false
		var rotation_amount: int
		rotation_amount  = randi_range(0, 1) * 90
		spawn_tower.rotate_y(deg_to_rad(rotation_amount))
		if rotation_amount == 90:
			rotation_amount = randi_range(0, 4) * 90
			spawn_tower.rotate_x(deg_to_rad(rotation_amount))
		elif rotation_amount == 0:
			rotation_amount  = randi_range(0, 4) * 90
			spawn_tower.rotate_z(deg_to_rad(rotation_amount))
	add_child(spawn_tower, true)
	meters += 9


func _on_collectable_timer_timeout() -> void:
	randomize()
	collectable_timer.wait_time = 1
	var collectable_type: String = collectable_chance.pick_random()
#	var rotation_amount: int  = randi_range(0, 4) * 90
	var collectable: PackedScene = collectable_catnip if collectable_type == "Catnip" else collectable_yarn
	var spawn_amount = 1 if collectable_type == "Catnip" else 9
	var collectable_position: float = randf_range(-3.5, 3.5)
	for count in spawn_amount:
		var spawn_collectable = collectable.instantiate()
		spawn_collectable.position.y = meters + count
		spawn_collectable.position.x = collectable_position
#		spawn_collectable.rotate_y(deg_to_rad(rotation_amount))
		add_child(spawn_collectable, true)
		


func _on_obstacle_timer_timeout() -> void:
	obstacle_timer.wait_time = 1
	if initial_standard_tower_count == 0:
		randomize()
		var obstacle_type: String = obstacle_chance.pick_random()
		var rotation_amount: int
	#	var rotation_amount: int  = randi_range(0, 4) * 90
		var obstacle: PackedScene = obstacle_hole
		var spawn_obstacle = obstacle.instantiate()
		if obstacle_type == "Rope":
			next_tower_piece_obstacle = true
			
		elif obstacle_type == "Hole":
			spawn_obstacle.position.y = meters + randf_range(1, 8)
			spawn_obstacle.position.x = randf_range(-3.5, 3.5)
	#		spawn_obstacle.rotate_y(deg_to_rad(rotation_amount))
		add_child(spawn_obstacle, true)
