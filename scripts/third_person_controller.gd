extends CharacterBody3D

# Third-person WASD movement, relative to the camera's facing. Pairs with
# orbit_camera.gd. Pressing W always walks "into the screen" regardless of where
# the camera has been orbited. This script never rotates the body and never reads
# the camera's angle back into the camera, so strafing with A/D moves in a
# straight line instead of circling.

@export var speed: float = 8.0
@export var run_speed: float = 14.0
@export var jump_velocity: float = 5.0

var _gravity: float = float(ProjectSettings.get_setting("physics/3d/default_gravity", 9.8))


func _physics_process(delta: float) -> void:
	# Camera-relative basis, flattened onto the ground plane. Falls back to world
	# axes until an active camera exists.
	var cam := get_viewport().get_camera_3d()
	var forward := Vector3.FORWARD
	var right := Vector3.RIGHT
	if cam != null:
		forward = -cam.global_transform.basis.z
		right = cam.global_transform.basis.x
	forward.y = 0.0
	right.y = 0.0
	forward = forward.normalized()
	right = right.normalized()

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (right * input_dir.x) + (forward * -input_dir.y)
	if direction.length() > 0.01:
		direction = direction.normalized()
	else:
		direction = Vector3.ZERO

	var current_speed := speed
	if Input.is_action_pressed("sprint"):
		current_speed = run_speed

	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed

	if not is_on_floor():
		velocity.y -= _gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	move_and_slide()
