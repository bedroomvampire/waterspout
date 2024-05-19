extends Area3D

@export var health : float = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale = Vector3(health / 100, health / 100, health / 100)
	
	if health <= 0:
		queue_free()
