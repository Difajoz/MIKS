extends Camera3D

# Decoupled third-person orbit camera. Resolves its target by the "player" group
# (then by a node named "Player"), follows its position, and orbits on mouse
# look. Because the orbit angle is stored state that only the mouse changes, and
# the camera position is computed from that state plus the target position (never
# from the camera's own basis), there is no rotational feedback loop — the view
# stays put while you strafe.

@export var distance: float = 5.0
@export var height: float = 1.5
@export var mouse_sensitivity: float = 0.005
@export var min_pitch: float = -1.3
@export var max_pitch: float = 0.4

var _yaw: float = 0.0
var _pitch: float = -0.35

@onready var _spring_arm: SpringArm3D = get_parent() as SpringArm3D
@onready var _head: Node3D = _spring_arm.get_parent() if _spring_arm else null


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if _spring_arm and _head:
		# Apply exported properties to the rig
		_spring_arm.spring_length = distance
		_head.position.y = height
		
		# Zero out local transform so SpringArm3D controls the camera position
		position = Vector3.ZERO
		rotation = Vector3.ZERO


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var motion := event as InputEventMouseMotion
		_yaw -= motion.relative.x * mouse_sensitivity
		_pitch -= motion.relative.y * mouse_sensitivity
		_pitch = clampf(_pitch, min_pitch, max_pitch)
	elif event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(_delta: float) -> void:
	if _head and _spring_arm:
		_head.rotation.y = _yaw
		_spring_arm.rotation.x = _pitch
