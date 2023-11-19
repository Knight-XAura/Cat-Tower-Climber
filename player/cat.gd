extends CharacterBody3D

#signal rotate_parent_node(direction: int)

@onready var detector: Area3D = $Detector

@onready var height: Label = $"../../CanvasLayer/MarginContainer/HUD/Height"
@onready var yarn: Label = $"../../CanvasLayer/MarginContainer/HUD/Yarn"
@onready var catnip: Label = $"../../CanvasLayer/MarginContainer/HUD/Catnip"

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cat_animation_player: AnimationPlayer = $cat_v2/AnimationPlayer


@onready var game_over_screen: Control = $"../../CanvasLayer/MarginContainer/GameOverScreen"


const SPEED: float = 5.0

var yarn_collected: int = 0

var on_catnip: bool = false
var is_climbing: bool = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var catnip_invisibility: Timer = $Catnip_Invisibility


func _ready() -> void:
	set_physics_process(false)
	animation_player.play("start")
	cat_animation_player.play("walk loop")
	await animation_player.animation_finished
	cat_animation_player.stop()
	cat_animation_player.play("hind_legs")
	await get_tree().create_timer(1.0).timeout
	cat_animation_player.stop()
	cat_animation_player.play("belly_crawl loop")
	rotate_x(deg_to_rad(90))
	is_climbing = true
	set_physics_process(true)
	

func _physics_process(delta: float) -> void:
#	if position.x >= 4 and Input.is_action_just_pressed("switch_side"):
#		rotate_parent_node.emit(1)
#	elif position.x <= -4 and Input.is_action_just_pressed("switch_side"):
#		rotate_parent_node.emit(-1)

	height.text = "Height: " + str(floorf(position.y / 9.0)) + "m"

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


func _on_detector_area_entered(area: Area3D) -> void:
	if area.name == "Catnip_Area":
		on_catnip = true
		catnip_invisibility.start()
		catnip.show()
		detector.set_collision_layer_value(5, false)
		detector.set_collision_mask_value(5, false)
	if area.name == "Yarn_Area":
		area.get_parent().queue_free()
		yarn_collected += 1
		yarn.text = "Balls of Yarn: " + str(yarn_collected)
	if on_catnip:
		return
	if area.name == "Hole_Area" or area.name == "Rope_Area":
		queue_free()
		game_over_screen.show()

func _on_catnip_invisibility_timeout() -> void:
	catnip.hide()
	detector.set_collision_layer_value(5, true)
	detector.set_collision_mask_value(5, true)
	on_catnip = false
