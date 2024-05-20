extends Node3D

var saved : int = 0
@export var saved_max : int = 16
@export var counter : Label
@export var saved_area : Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	saved = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	counter.text = "Saved: " + str(saved) + "/" + str(saved_max)
	
	if saved == saved_max:
		get_tree().change_scene_to_file("res://node_3d.tscn")


func _on_area_3d_body_entered(body):
	if body.has_node("NPC"):
		saved += 1
		body.queue_free()
