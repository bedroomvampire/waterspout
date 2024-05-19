extends Area3D

@export var health : float = 100
var dmg : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale = Vector3(health / 100, health / 100, health / 100)
	
	if health <= 0:
		queue_free()
	
	if dmg:
		health -= 10 * delta


func _on_area_entered(area):
	if area.has_node("Water"):
		pass
		#print("ya")
