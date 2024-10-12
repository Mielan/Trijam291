extends CharacterBody3D  # Or KinematicBody3D for Godot 3.x

# Variables for movement and dash
var move_speed = 10.0
var dash_speed = 40.0  # Speed when dashing
var dash_duration = 0.3  # Duration of the dash in seconds
var gravity = -39.8
var jump_force = 20.0 

# Internal state for dashing
var is_dashing = false
var dash_timer = 0.0


# Camera offset and smoothing factor
var camera_offset = Vector3(0, 5, -20)  # Adjust this for camera's default position
var camera_smooth_speed = 5.0  # Adjust this for smoother or faster camera catching up


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

	# Check for dash input (Shift key)
	if Input.is_action_just_pressed("ui_shift") and not is_dashing:
		is_dashing = true
		dash_timer = dash_duration

	# Handle dashing
	if is_dashing:
		dash_timer -= delta
		if dash_timer > 0:
			direction = direction.normalized() * dash_speed  # Apply dash speed
		else:
			is_dashing = false  # End the dash

	if not is_dashing:
		direction = direction.normalized() * move_speed  # Regular speed when not dashing

	# Apply movement
	velocity.x = direction.x  # Only move on X-axis
	move_and_slide()  # Move the player with collisions

	# Lock the player's Z position (for 2D-like movement)
	global_transform.origin.z = 0
  # Smooth camera follow logic
	var camera = $Camera3D  # Get the camera node
	var target_position = global_transform.origin + camera_offset  # Desired camera position

	# Use lerp to make the camera follow smoothly
	camera.global_transform.origin.x = lerp(camera.global_transform.origin.x, target_position.x, delta * camera_smooth_speed)
	camera.global_transform.origin.y = lerp(camera.global_transform.origin.y, target_position.y, delta * camera_smooth_speed)
	camera.global_transform.origin.z = -target_position.z  # Keep Z fixed so camera doesn't shift along the Z-axis


# Print the camera's position
	print("Camera Position: ", camera.global_transform.origin)

# Get the camera's rotation in radians, convert to degrees
	var rotation_degrees = camera.rotation_degrees
	print("Camera Rotation (degrees): ", rotation_degrees)
