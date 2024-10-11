extends CharacterBody3D  # For Godot 4.x, or KinematicBody3D for Godot 3.x

var move_speed = 10.0
var jump_force = 10.0
var gravity = -9.8

func _physics_process(delta):
	# Apply gravity to the built-in velocity
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Vector3.ZERO

	# Movement along the X-axis (left/right)
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	elif Input.is_action_pressed("ui_left"):
		direction.x -= 1

	# Jumping along the Y-axis
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_force

	# Apply movement
	direction = direction.normalized() * move_speed
	velocity.x = direction.x  # Only move on X-axis

	move_and_slide()  # Move the player with collisions

	# Lock the player's Z position (for 2D-like movement)
	global_transform.origin.z = 0
