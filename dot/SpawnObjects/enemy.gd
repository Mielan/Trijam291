extends "res://script/playerwSkill.gd"  # Inherits from the Player script

# Additional enemy-specific variables
var player_detected = false  # Track if the player is detected
var patrol_area = null  # Define the patrol area for the enemy

func _ready():
	# Call the parent class's ready function (Player)
	super._ready()

	# Initialize enemy-specific behavior
	start_patrol()

# Enemy patrolling behavior
func start_patrol():
	# Logic for random or predefined patrol area walking
	# You can define multiple waypoints or a random movement in an area
	pass

# Function to detect if the player is in range (basic vision cone or proximity)
func detect_player():
	var player_position = get_tree().current_scene.get_node("Player").global_transform.origin
	var distance_to_player = global_transform.origin.distance_to(player_position)

	if distance_to_player < 20:  # Example detection range
		player_detected = true
	else:
		player_detected = false

# Update function for handling enemy AI behavior
func _physics_process(_delta):
	detect_player()  # Continuously detect if the player is in range

	if player_detected:
		move_toward_player()  # Move toward the player and attack
	else:
		patrol()  # Otherwise, patrol the area

# Function to move toward the player
func move_toward_player():
	var player_position = get_tree().current_scene.get_node("Player").global_transform.origin
	var direction_to_player = (player_position - global_transform.origin).normalized()

	velocity.x = direction_to_player.x * move_speed
	velocity.z = direction_to_player.z * move_speed  # Keep Z-axis locked to 0 for 2D-like movement
	move_and_slide()

# Function to handle patrol behavior
func patrol():
	# Patrol logic for enemy when the player is not detected
	pass
