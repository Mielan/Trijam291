extends Area2D

# Signal when the player enters the fall zone
func _ready():
	connect("body_entered", Callable(self, "_on_FallZone_body_entered"))

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().reload_current_scene()  # Restart the scene for losing
