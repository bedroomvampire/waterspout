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

var health : float = 100
var dmg : bool

var water : float = 100
var is_entered : bool
@onready var timer = $Timer

#bruh moment
@onready var raycast_1 =  $watergunner2c2/RayCast3D
@onready var raycast_2 =  $watergunner2c2/RayCast3D2
@onready var raycast_3 =  $watergunner2c2/RayCast3D3
@onready var raycast_4 =  $watergunner2c2/RayCast3D4
@onready var raycast_5 =  $watergunner2c2/RayCast3D5
@onready var raycast_6 =  $watergunner2c2/RayCast3D6


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var _delta = 0.0

func _process(delta):
	health_prog_bar.value = health
	water_prog_bar.value = water
	
	arm.global_position = arm_pos.global_position
	arm.global_rotation.y = lerp_angle(arm.global_rotation.y, arm_pos.global_rotation.y, 10 * delta)
	
	var cam_dir = Input.get_axis("cam_right", "cam_left")
	if cam_dir:
		global_rotation.y += cam_dir * 2 * delta
	
	if raycast_1.is_colliding():
		if raycast_1.get_collider().has_node("Fire"):
			raycast_1.get_collider().dmg = true
	elif raycast_2.is_colliding():
		if raycast_2.get_collider().has_node("Fire"):
			raycast_2.get_collider().dmg = true
	if raycast_3.is_colliding():
		if raycast_3.get_collider().has_node("Fire"):
			raycast_3.get_collider().dmg = true
	elif raycast_4.is_colliding():
		if raycast_4.get_collider().has_node("Fire"):
			raycast_4.get_collider().dmg = true
	if raycast_5.is_colliding():
		if raycast_5.get_collider().has_node("Fire"):
			raycast_5.get_collider().dmg = true
	elif raycast_6.is_colliding():
		if raycast_6.get_collider().has_node("Fire"):
			raycast_6.get_collider().dmg = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY
	
	if water:
		if Input.is_action_pressed("ui_accept"):
			_water(delta)
		else:
			unwater()
	if water <= 1:
		unwater()
	
	if dmg:
		health -= 15 * delta
	
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

func _water(delta):
	water -= 10 * delta
	water_spray.emitting = true
	area_detection.monitoring = false
	raycast_1.enabled = true
	raycast_2.enabled = true
	raycast_3.enabled = true
	raycast_4.enabled = true
	raycast_5.enabled = true
	raycast_6.enabled = true

func unwater():
	water_spray.emitting = false
	area_detection.monitoring = true
	raycast_1.enabled = false
	raycast_2.enabled = false
	raycast_3.enabled = false
	raycast_4.enabled = false
	raycast_5.enabled = false
	raycast_6.enabled = false

func _on_area_3d_area_entered(area):
	if area.has_node("Fire"):
		is_entered = true
		area.dmg = false
		#area.health -= 10

func _on_area_3d_area_exited(area):
	if area.has_node("Fire"):
		is_entered = false
		#area.dmg = false


func _on_timer_timeout(area):
	pass # Replace with function body.
