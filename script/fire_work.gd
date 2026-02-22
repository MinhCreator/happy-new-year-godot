extends RigidBody3D

@export var speed : float = 0.0
@export var speedRate : float = 0.0
@onready var thruster: Node3D = $thruster

@onready var fuse = $fuse

@onready var animation_player = $AnimationPlayer
@onready var boom_range = $boom_range
@onready var audio_stream_player_3d = $AudioStreamPlayer3D

@export var fuse_duration = 0.9

var boom_sound = preload("res://sfx/firework-explodes.mp3")
#var thrusted_sound = preload("res://sfx/firework-launch.wav")
var lit = false
var exploding = false

func _ready():
	fuse.set_duration(randf_range(fuse_duration,fuse_duration+0.2))
	if lit:
		fuse.ignited = true
		audio_stream_player_3d.play()
	apply_torque(Vector3(randf()/10,randf()/10,randf()/10))

func light():
	if !lit:
		lit = true
		fuse.set_duration(randf_range(fuse_duration,fuse_duration+0.2))
		fuse.ignited = true
		audio_stream_player_3d.play()

func boom():
	animation_player.play("boom")
	audio_stream_player_3d.stop()
	audio_stream_player_3d.stream = boom_sound;
	audio_stream_player_3d.play()
	if !exploding:
		exploding = true
		for fireworks in $boom_range.get_overlapping_bodies():
			if fireworks.has_method("light") && fireworks != self:
				fireworks.apply_force((position.direction_to(fireworks.position)*50.0)+ Vector3.UP*30.0)
				fireworks.light()
	

func _on_animation_player_animation_finished(anim_name):
	queue_free()
func launch(delta):
	$".".linear_velocity = global_transform.basis.y * (speed * speedRate) * delta
	
	# Move forward along its local -Z axis
