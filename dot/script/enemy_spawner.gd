extends Node3D

var enemy_scene = preload("res://SpawnObjects/enemy.tscn")  # Preload the enemy scene
var spawn_points = []  # List of spawn positions for enemies

# Called when the scene is ready
func _ready():
	print_scene_tree()
	call_deferred("_find_spawn_points")

# Debug Statement
func print_scene_tree():
	print("=== Scene Tree ===")
	_print_tree_recursive(get_tree().root)
	print("===================")

func _print_tree_recursive(node):
	print(node.name, " (", node, ")")
	for child in node.get_children():
		_print_tree_recursive(child)

func _find_spawn_points():
	# Define spawn points as Position3D nodes in your scene
	spawn_points = [
		get_node("SpawnPosition")
		#get_node("SpawnPoint2"),
		#get_node("SpawnPoint3")
	]

	# Spawn enemies at each spawn point
	for spawn_point in spawn_points:
		if spawn_point != null:  # Ensure the spawn point exists
			spawn_enemy_at(spawn_point.global_transform.origin)
		else:
			print("Spawn point not found or is null!")

# Function to spawn an enemy at a given position
func spawn_enemy_at(position):
	var enemy_instance = enemy_scene.instantiate()
	
	# First, add the enemy to the scene tree
	add_child(enemy_instance)
	
	# Set the enemy's position after it has been added to the tree
	enemy_instance.global_transform.origin = position
