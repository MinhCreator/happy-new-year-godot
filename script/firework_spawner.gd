extends Node3D

@export var firework = preload("res://fireWork.tscn")
@onready var area : CollisionShape3D = $DebugArea
@onready var debugPoint1: MeshInstance3D = $DebugRangepoint1
@onready var debugPoint2: MeshInstance3D = $DebugRangepoint2
@onready var debugPoint3: MeshInstance3D = $DebugRangepoint3
@onready var debugPoint4: MeshInstance3D = $DebugRangepoint4
@onready var maker : Marker3D = $Marker3D
# Called when the node enters the scene tree for the first time.

var edgeX 
var edgeY
func _ready():
	# Ensure the Timer starts automatically
	#$Timer.start()
	# Optional: Initialize the random number generator
	randomize()
	
	edgeX = debugPoint1.position.x + debugPoint2.position.x
	edgeY  = debugPoint1.position.y + debugPoint2.position.y

func spawn_range():
	return pow(sqrt(pow(edgeX, 2) + pow(edgeY, 2)), 2)
# Function called when the Timer reaches zero (connected via signal)
func _on_timer_timeout():
	# 1. Create a new instance of the object scene
	var object_instantiate = firework.instantiate()
	
	# 2. Add the new instance to the scene tree
	# It's best to add it as a child of a common parent node (like the main game node)
	# This prevents the spawner's transform from affecting the object if the spawner moves
	get_parent().add_child(object_instantiate)
	
	# 3. Set the global position of the new instance to the spawner's position
	object_instantiate.global_transform.origin = global_transform.origin
	
	# Optional: For random positions in an area (see Step 4)
	var spawn_ranges = 15
	object_instantiate.global_transform.origin.x += randf_range(-spawn_ranges, spawn_ranges)
	object_instantiate.global_transform.origin.z += randf_range(-spawn_ranges, spawn_ranges)
