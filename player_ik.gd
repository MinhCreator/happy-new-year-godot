@tool
extends CharacterBody3D

@onready var ik_left = $model/Armature/GeneralSkeleton/SkeletonIK_L
@onready var ik_right = $model/Armature/GeneralSkeleton/SkeletonIK_R
@export var step_height: float = 0.5
@export var lerp_speed: float = 20.0
@onready var Ray_L : RayCast3D = $model/Armature/GeneralSkeleton/SkeletonIK_L/RayCast_L
@onready var Ray_R : RayCast3D = $model/Armature/GeneralSkeleton/SkeletonIK_R/RayCast_R
@onready var Target_L : Marker3D = $model/Armature/GeneralSkeleton/SkeletonIK_L/Marker_L
@onready var Target_R : Marker3D = $model/Armature/GeneralSkeleton/SkeletonIK_R/Marker_R


func _ready():
	ik_left.start()
	ik_right.start()
	

func _physics_process(delta):
	process_foot_ik(Ray_L, Target_L, delta)
	process_foot_ik(Ray_R, Target_R, delta)

func process_foot_ik(ray: RayCast3D, target: Marker3D, delta: float):
	if ray.is_colliding():
		var hit_pos = ray.get_collision_point()
		var hit_normal = ray.get_collision_normal()
		
		# Position the target slightly above the floor hit point
		var goal_pos = hit_pos + Vector3(0, 0.1, 0)
		target.global_position = target.global_position.lerp(goal_pos, lerp_speed * delta)
		
		# Align foot rotation with the floor slope
		var look_dir = -target.global_transform.basis.z
		var foot_basis = Basis.looking_at(look_dir, hit_normal)
		target.global_basis = target.global_basis.slerp(foot_basis, lerp_speed * delta)
