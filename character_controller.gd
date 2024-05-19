extends CharacterBody3D

@export var arm : SpringArm3D
@export var arm_pos : Marker3D
@export var model : Node3D
@export var water_spray : GPUParticles3D
@export var area_detection : Area3D
@export var health_prog_bar : ProgressBar
@export var water_prog_bar : ProgressBar
@onready var anim_tree = $watergunner2c2/AnimationTree

const current_speed = 5.0
const JUMP_VELOCITY = 4.5

var fire : Area3D
var is_entered : bool

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var _delta = 0.0

func _process(delta):
	arm.global_position = arm_pos.global_position
	arm.global_rotation.y = lerp_angle(arm.global_rotation.y, arm_pos.global_rotation.y, 15 * delta)
	
	var cam_dir = Input.get_axis("cam_right", "cam_left")
	if cam_dir:
		global_rotation.y += cam_dir * 2 * delta
	
	#if area_detection.
	

func _physics_process(delta):
	var _delta = 1 * delta
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("ui_accept"):
		water_spray.emitting = true
		area_detection.monitoring = true
	else:
		water_spray.emitting = false
		area_detection.monitoring = false
	
	if fire && area_detection.monitoring:
		fire.health -= 10 * delta
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * current_speed, 15 * delta)
		velocity.z = lerp(velocity.z, direction.z * current_speed, 15 * delta)
		model.global_rotation.y = lerp_angle(model.global_rotation.y, atan2(velocity.x, velocity.z), 15 * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, 15 * delta)
		velocity.z = lerp(velocity.z, 0.0, 15 * delta)
	
	anim_tree.set("parameters/conditions/walk", direction)
	anim_tree.set("parameters/conditions/stand", !direction)
	
	move_and_slide()


func _on_area_3d_area_entered(area):
	if area.has_node("Fire"):
		is_entered = true
		fire = area

func _on_area_3d_area_exited(area):
	is_entered = false
	fire = null
