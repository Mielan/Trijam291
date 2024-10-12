extends Control

var player = null

# This function will be called to set the player reference when the skill tree is opened
func set_player(p):
	player = p
	update_skill_labels()

func _ready():
	# You don't need to set the player here if you're passing it through set_player()
	# Ensure you call set_player() when you open this UI
	update_skill_labels()

func _on_speed_button_pressed() -> void:
	if player != null:
		player.upgrade_skill("speed")
		update_skill_labels()

func _on_jump_button_pressed() -> void:
	if player != null:
		player.upgrade_skill("jump")
		update_skill_labels()

func _on_attack_button_pressed() -> void:
	if player != null:
		player.upgrade_skill("attack")
		update_skill_labels()

func _on_health_button_pressed() -> void:
	if player != null:
		player.upgrade_skill("health")
		update_skill_labels()

# Function to update skill labels
func update_skill_labels():
	if player == null:
		return  # Avoid updating if player is not set yet

	# Update labels based on the player's current skill levels, check if the nodes exist
	var speed_label = get_node("Panel/VBoxContainer/SpeedButton/Label")
	if speed_label != null:
		speed_label.text = "Speed: %d" % player.skill_tree["speed"]["level"]

	var jump_label = get_node("Panel/VBoxContainer/JumpButton/Label")
	if jump_label != null:
		jump_label.text = "Jump: %d" % player.skill_tree["jump"]["level"]

	var health_label = get_node("Panel/VBoxContainer/AttackButton/Label")
	if health_label != null:
		health_label.text = "Healtah: %d" % player.skill_tree["health"]["level"]

	var attack_label = get_node("Panel/VBoxContainer/HealthButton/Label")
	if attack_label != null:
		attack_label.text = "Attack: %d" % player.skill_tree["attack"]["level"]

	var skillPointLabel = get_node("Panel/SkillPoints")
	if skillPointLabel != null:
		skillPointLabel.text = "Skill Points Remaining: %d" %player.skill_points

func _on_close_pressed() -> void:
	queue_free()  # Close the skill tree UI
