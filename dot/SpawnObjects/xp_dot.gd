extends Area3D

var xp_value = 10  # Amount of XP to give when the dot is collected

# Function to handle collision with the player
func _on_body_entered(body):
	if body.name == "Player":  # Ensure it's the player
		body.gain_xp(xp_value)  # Call player's gain_xp method
		queue_free()  # Remove the dot from the scene when collected
