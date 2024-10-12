extends "res://script/player.gd"  # Inherits from the Player script

# Additional enemy-specific variables
var player_detected = false  # Track if the player is detected
var patrol_area = null  # Define the patrol area for the enemy

# Override player abilities with 70% scaling for the enemy
func _ready():
	
	GlobalStats.connect("player_stats_updated", Callable(self, "_on_player_stats_updated"))


	# Scale initial stats based on 70% of player's initial values
	scale_enemy_stats()

# Function to scale the enemy's stats
func scale_enemy_stats():
	move_speed = GlobalStats.player_stats["speed"] * 0.7
	jump_force = GlobalStats.player_stats["jump"] * 0.7
	#attack_power = GlobalStats.player_stats["attack"] * 0.7
	#current_health = GlobalStats.player_stats["health"] * 0.7

	# Initialize enemy-specific behavior
	start_patrol()

# Function to handle player stats updates
func _on_player_stats_updated():
	# Re-scale stats based on updated player values
	scale_enemy_stats()
# Enemy patrolling behavior
func start_patrol():
	# Logic for random or predefined patrol area walking
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
func _physics_process(delta):
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

# Function to handle input and debug printing of stats
func _input(event):
	if Input.is_action_just_pressed("ui_debug2"):  # Check if ui_debug2 is pressed
		print_enemy_stats()

# Function to print the enemy's current stats
func print_enemy_stats():
	print("=== Enemy Stats ===")
	print("Move Speed: ", move_speed)
	print("Jump Force: ", jump_force)
	print("Dash Speed: ", dash_speed)
	print("Detected Player: ", player_detected)
	print("===================")
