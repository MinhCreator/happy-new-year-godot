extends MeshInstance3D

@onready var sparks_particles = $sparks_particles
@onready var sparks_light = $sparks_light
@onready var thruster = $"../thruster"

@export var firework : RigidBody3D

var ignited = true

var duration = 1.0
var current_time = 0.0

var y_distance = 0.06
var y_starting = 0.0

func _ready():
	current_time = duration
	y_starting = position.y

func set_duration(new_duration):
	duration = new_duration
	current_time = duration

func _process(delta):
	if ignited:
		#sparks_light.show()
		thruster.show()
		firework.launch(delta)
		#sparks_particles.emitting = true
		current_time -= delta
		position.y = (y_starting-y_distance)+((current_time/duration)*y_distance)
		if current_time <= 0.0:
			#sparks_particles.emitting = false
			ignited = false
			#sparks_light.hide()
			firework.boom();
			queue_free()
