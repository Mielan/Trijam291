extends Area3D

# Signal when the player enters the fall zone
func _ready():
	# Connect the body_entered signal to the function
	connect("body_entered", Callable(self, "_on_FallZone_body_entered"))

# Function that triggers when a body enters the area
func _on_FallZone_body_entered(body: Node3D) -> void:
	if body.name == "Player":  # Check if the object entering the zone is the player
		get_tree().reload_current_scene()  # Restart the scene for losing
