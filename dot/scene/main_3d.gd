extends Node3D  # This should match the type of your root node

var dot_scene = preload("res://SpawnObjects/xpDot.tscn")  # Preload the Dot scene
var spawn_area_min = Vector3(-100, 5, 0)  # Min XYZ coordinates for spawning dots
var spawn_area_max = Vector3(100, 10, 0)  # Max XYZ coordinates for spawning dots

var max_dots = 20  # Maximum number of dots
var current_dots = 0  # Track how many dots have been spawned
var dot_spawn_timer = null  # Reference to the timer
func spawn_single_dot():
	if current_dots < max_dots:
		var dot_instance = dot_scene.instantiate()
		
		# First, add the dot to the scene tree
		call_deferred("add_child", dot_instance)
		
		# After it has been added, defer setting the position to make sure it's inside the tree
		# Ensure the position is set after the dot is inside the tree
		dot_instance.call_deferred("set_position", Vector3(
			randf_range(spawn_area_min.x, spawn_area_max.x),
			randf_range(spawn_area_min.y, spawn_area_max.y),
			randf_range(spawn_area_min.z, spawn_area_max.z)
		))
		current_dots += 1

		# Restart the timer if more dots need to be spawned
		if current_dots < max_dots:
			dot_spawn_timer.start()

# Helper function to set the position after the dot has been added to the tree
func set_position_after_added():
	var random_position = Vector3(
		randf_range(spawn_area_min.x, spawn_area_max.x),
		randf_range(spawn_area_min.y, spawn_area_max.y),
		randf_range(spawn_area_min.z, spawn_area_max.z)
	)
	global_transform.origin = random_position

# Called when the scene is ready
func _ready():
	# Use call_deferred to start the dot spawning process after the scene setup
	call_deferred("_start_dot_spawning")

# Start dot spawning after the scene is fully ready
func _start_dot_spawning():
	dot_spawn_timer = $DotSpawnTimer
	if dot_spawn_timer != null:
		dot_spawn_timer.wait_time = 2.0  # Set to 2 seconds between each spawn
		dot_spawn_timer.one_shot = true  # Only run the timer once per call
		dot_spawn_timer.start()  # Start the first dot spawn
	else:
		print("Error: DotSpawnTimer node not found!")

# Connect this function to the timer's timeout signal
#func _on_DotSpawnTimer_timeout():
#	spawn_single_dot()


func _on_dot_spawn_timer_timeout() -> void:
	spawn_single_dot()
