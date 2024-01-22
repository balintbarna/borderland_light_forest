extends CharacterBody3D

@export var MOUSE_SENSITIVITY = 0.1
@export var base_speed = 1  # m/s
@onready var camera = $Camera3D

func _physics_process(delta):
	handle_capture()
	handle_move(delta)

func _input(event):
	if event is InputEventMouseMotion and is_captured():
		handle_turn_from_mouse(event)

func handle_move(delta):
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
	var speed = base_speed
	if Input.is_action_pressed("faster"):
		speed *= 2
	if Input.is_action_pressed("slower"):
		speed *= 0.5
	direction *= delta * speed
	global_position += direction

func handle_turn_from_mouse(event: InputEventMouseMotion):
	camera.rotate_x(deg_to_rad(event.relative.y * MOUSE_SENSITIVITY * -1))
	self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * -1))
	var cr = camera.rotation_degrees
	cr.x = clamp(cr.x, -70, 70)
	camera.rotation_degrees = cr

func handle_capture():
	if Input.is_action_just_pressed("engage"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_released("engage"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func is_captured():
	return Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
