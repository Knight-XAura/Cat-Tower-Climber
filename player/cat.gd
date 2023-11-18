extends CharacterBody3D

signal rotate_parent_node(direction: int)


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cat_animation_player: AnimationPlayer = $cat_v2/AnimationPlayer


const SPEED: float = 5.0

var can_switch: bool = false
var switch_direction: int = 0
var is_climbing: bool = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	set_physics_process(false)
	animation_player.play("start")
	await animation_player.animation_finished
	cat_animation_player.play("hind_legs")
	await get_tree().create_timer(1.0).timeout
	cat_animation_player.stop()
	cat_animation_player.play("belly_crawl")
	rotate_x(deg_to_rad(90))
	is_climbing = true
	set_physics_process(true)
	

func _physics_process(delta: float) -> void:
	if position.x >= 4 and Input.is_action_just_pressed("switch_side"):
		rotate_parent_node.emit(1)
	elif position.x <= -4 and Input.is_action_just_pressed("switch_side"):
		rotate_parent_node.emit(-1)
			
	# Fixes every other run when tower pieces stop detecting you
	position.z = 5.5
	
	# Climb kitty climb!
	if is_climbing:
		velocity.y = gravity

	velocity.x = Input.get_axis("move_left", "move_right")
	if velocity.x:
		velocity.x *= SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	position.x = clampf(position.x, -4.25, 4.25)
