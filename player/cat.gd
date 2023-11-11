extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


const SPEED: float = 5.0


var is_climbing: bool = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	animation_player.play("start")
	await animation_player.animation_finished
	is_climbing = true
	

func _physics_process(delta: float) -> void:
	# Fixes every other run failing after about 25 tower pieces
	position.z = 5
	
	# Climb kitty climb!
	if is_climbing:
		velocity.y = gravity

	velocity.x = Input.get_axis("move_left", "move_right")
	if velocity.x:
		velocity.x *= SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	pass
	
