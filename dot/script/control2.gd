extends Control

# Reference to the player
onready var player = get_node("/root/Player")  # Adjust path according to your scene

# Upgrade buttons
onready var upgrade_speed_button = $Panel/VBoxContainer/UpgradeSpeedButton
onready var upgrade_dash_button = $Panel/VBoxContainer/UpgradeDashButton
onready var upgrade_jump_button = $Panel/VBoxContainer/UpgradeJumpButton

# Labels to show current levels
onready var speed_level_label = $Panel/VBoxContainer/SpeedLevelLabel
onready var dash_level_label = $Panel/VBoxContainer/DashLevelLabel
onready var jump_level_label = $Panel/VBoxContainer/JumpLevelLabel

# Label for skill points
onready var skill_points_label = $Panel/SkillPointsLabel

# Function to update the UI (call this after upgrading skills)
func update_ui():
	if player:  # Ensure the player node is found
		speed_level_label.text = "Speed Level: %d" % player.skill_tree["speed"]["level"]
		dash_level_label.text = "Dash Level: %d" % player.skill_tree["dash"]["level"]
		jump_level_label.text = "Jump Level: %d" % player.skill_tree["jump"]["level"]
		skill_points_label.text = "Skill Points: %d" % player.skill_points
	else:
		print("Player not found!")

# Connect buttons to the upgrade functions
func _ready():
	if upgrade_speed_button:
		upgrade_speed_button.connect("pressed", self, "_on_UpgradeSpeedButton_pressed")
	if upgrade_dash_button:
		upgrade_dash_button.connect("pressed", self, "_on_UpgradeDashButton_pressed")
	if upgrade_jump_button:
		upgrade_jump_button.connect("pressed", self, "_on_UpgradeJumpButton_pressed")
	update_ui()  # Initial UI update

# Functions to upgrade skills when buttons are pressed
func _on_UpgradeSpeedButton_pressed():
	if player:
		player.upgrade_skill("speed")
		update_ui()

func _on_UpgradeDashButton_pressed():
	if player:
		player.upgrade_skill("dash")
		update_ui()

func _on_UpgradeJumpButton_pressed():
	if player:
		player.upgrade_skill("jump")
		update_ui()
