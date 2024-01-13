extends CharacterBody3D

@export var MOUSE_SENSITIVITY = 0.1
@export var speed = 1  # m/s
@onready var camera = $Camera3D

func _process(_delta):
	if Input.is_action_just_pressed("engage"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if is_captured() else Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if direction == Vector3.ZERO:
		return
	direction = direction.normalized()
	direction = camera.global_basis * direction
	direction *= delta * speed
	global_position += direction

func _input(event):
	if event is InputEventMouseMotion and is_captured():
		mouse_motion_character_rotation(event)

func mouse_motion_character_rotation(event: InputEventMouseMotion):
	camera.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY * -1))
	self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))
	var cr = camera.rotation_degrees
	cr.x = clamp(cr.x, -70, 70)
	camera.rotation_degrees = cr

func is_captured():
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
