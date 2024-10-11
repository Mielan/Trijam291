extends Area2D

func _ready():
	connect("body_entered", Callable(self, "_on_WinZone_body_entered"))

func _on_WinZone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Player entered the win zone!")
		get_tree().change_scene_to_file("res://Win_Screen.tscn")  # Correct function name for Godot 4
