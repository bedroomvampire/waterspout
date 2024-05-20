extends CharacterBody3D

@onready var anim_tree = $watergunner2c2/AnimationTree

const current_speed = 5.0
const JUMP_VELOCITY = 4.5

var health : float = 100
var dmg : bool

var water : float = 100
var is_entered : bool
@onready var timer = $Timer

var target = null
var chase = false
@onready var agent = $NavigationAgent3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	health = 100

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	velocity = Vector3.ZERO
	if chase:
		agent.set_target_position(target.global_transform.origin)
		var next_point = agent.get_next_path_position()
		velocity = (next_point - global_transform.origin).normalized() * current_speed
		rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), 15.0 * delta)
	
	if dmg:
		health -= 32.5 * delta
	
	if health <= 0.1:
		queue_free()
	
	anim_tree.set("parameters/conditions/walk", velocity.length() >= 0.1)
	anim_tree.set("parameters/conditions/stand", !velocity.length() >= 0.1)
	
	move_and_slide()

func _on_area_3d_body_entered(body):
	if body.name == "Player":
		chase = true
		target = body
