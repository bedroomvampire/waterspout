extends CharacterBody3D

@export var model : Node3D
@export var water_spray : GPUParticles3D
@onready var anim_tree = $watergunner2c2/AnimationTree

const current_speed = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _process(delta):
	var cam_dir = Input.get_axis("cam_right", "cam_left")
	if cam_dir:
		global_rotation.y += cam_dir * 2 * delta
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("ui_accept"):
		water_spray.emitting = true
	else:
		water_spray.emitting = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if !Input.is_action_pressed("ui_accept"):
			velocity.x = lerp(velocity.x, direction.x * current_speed, 15 * delta)
			velocity.z = lerp(velocity.z, direction.z * current_speed, 15 * delta)
			model.global_rotation.y = lerp_angle(model.global_rotation.y, atan2(velocity.x, velocity.z), 15 * delta)
		else:
			model.global_rotation.y = lerp_angle(model.global_rotation.y, atan2(direction.x, direction.z), 15 * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, 15 * delta)
		velocity.z = lerp(velocity.z, 0.0, 15 * delta)
	
	anim_tree.set("parameters/conditions/walk", direction && !Input.is_action_pressed("ui_accept"))
	anim_tree.set("parameters/conditions/stand", !direction)
	
	move_and_slide()
