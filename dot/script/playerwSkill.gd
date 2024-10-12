extends CharacterBody3D

# Variables for movement and dash
var move_speed = 10.0
var dash_speed = 40.0  # Speed when dashing
var dash_duration = 0.3  # Duration of the dash in seconds
var gravity = -39.8
var jump_force = 20.0
var attack_power = 10.0
var max_health = 100.0

# Internal state for dashing
var is_dashing = false
var dash_timer = 0.0

# Camera offset and smoothing factor
var camera_offset = Vector3(0, 5, -20)
var camera_smooth_speed = 5.0

# Skill Tree Definition
var skill_tree = {
	"speed": {"level": 0, "max_level": 5, "base_value": 10.0, "increase_per_level": 5.0},
	"dash": {"level": 0, "max_level": 3, "base_value": 0.3, "increase_per_level": 0.2},
	"jump": {"level": 0, "max_level": 3, "base_value": 20.0, "increase_per_level": 10.0},
	"health": {"level": 0, "max_level": 3, "base_value": 100, "increase_per_level": 50},
	"attack": {"level": 0, "max_level": 3, "base_value": 10, "increase_per_level": 10}
}


var skill_points = 1  # Points available for upgrading skills

# variable for ui nodes
var xp_bar
var xp_label
var health_bar
var health_label
var task_list_container
var skill_points_label
var skill_tree_note

# Variable to track if the skill tree has been opened
var skill_tree_opened = false

func _ready():
	# Load the PlayerUI scene
	call_deferred("_add_ui_scene")

func _add_ui_scene():
	var ui_scene = load("res://UI/ui.tscn").instantiate()
	get_tree().current_scene.add_child(ui_scene)

	# Get references to the UI elements
	xp_bar = ui_scene.get_node("XPBar")
	xp_label = ui_scene.get_node("XPBar/XPLabel")
	health_bar = ui_scene.get_node("HealthBar")
	health_label = ui_scene.get_node("HealthBar/HealthLabel")
	task_list_container = ui_scene.get_node("TaskListContainer")
	skill_points_label = ui_scene.get_node("SkillPointsLabel")
	skill_tree_note = ui_scene.get_node("SkillTreeNote")
	
var current_xp = 0
var xp_to_next_level = 50
var level = 1

func gain_xp(amount):
	current_xp += amount
	if current_xp >= xp_to_next_level:
		current_xp -= xp_to_next_level
		level_up()

	# Update the XP bar and label
	xp_bar.value = current_xp
	xp_bar.max_value = xp_to_next_level
	xp_label.text = "XP: %d/%d" % [current_xp, xp_to_next_level]

func level_up():
	level += 1
	skill_points += 1  # Gain 1 skill point per level up
	xp_to_next_level += 50  # Increase the XP required for the next level
	
	# Update the skill points label
	skill_points_label.text = "Skill Points: %d" % skill_points

	
	print("Level up! Now level", level)

var current_health = 100
#var max_health = 100

func set_health(value):
	current_health = clamp(value, 0, max_health)

	# Update the health bar and label
	health_bar.value = current_health
	health_bar.max_value = max_health
	health_label.text = "Health: %d/%d" % [current_health, max_health]

func add_task(task_description):
	var task_label = Label.new()
	task_label.text = task_description
	task_list_container.add_child(task_label)

func remove_task(task_label):
	task_list_container.remove_child(task_label)
	task_label.queue_free()


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Vector3.ZERO

	# Movement along the X-axis
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	elif Input.is_action_pressed("ui_left"):
		direction.x -= 1

	# Jumping along the Y-axis
	if is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_force

	# Dashing
	if Input.is_action_just_pressed("ui_shift") and not is_dashing:
		is_dashing = true
		dash_timer = dash_duration

	if is_dashing:
		dash_timer -= delta
		if dash_timer > 0:
			direction = direction.normalized() * dash_speed
		else:
			is_dashing = false

	if not is_dashing:
		direction = direction.normalized() * move_speed

	velocity.x = direction.x
	move_and_slide()

	global_transform.origin.z = 0  # Lock Z-axis for 2D-like movement

	# Camera follow logic
	var camera = $Camera3D
	var target_position = global_transform.origin + camera_offset
	camera.global_transform.origin.x = lerp(camera.global_transform.origin.x, target_position.x, delta * camera_smooth_speed)
	camera.global_transform.origin.y = lerp(camera.global_transform.origin.y, target_position.y, delta * camera_smooth_speed)
	camera.global_transform.origin.z = -target_position.z

func _input(_event):
	#if Input.is_action_pressed("ui_skill_1"):
	#	upgrade_skill("speed")
	#if Input.is_action_pressed("ui_skill_2"):
	#	upgrade_skill("dash")
	#if Input.is_action_pressed("ui_skill_3"):
	#	upgrade_skill("jump")
	if Input.is_action_just_pressed("ui_open_skill_tree"):
		open_skill_tree()
		if not skill_tree_opened:
			skill_tree_note.hide()
			skill_tree_opened = true
	elif Input.is_action_just_pressed("ui_debug"):  # Assuming "ui_debug" is mapped to a key like "D"
		debug_player_stats()

func open_skill_tree():
	var skill_tree_scene = load("res://UI/SkillTree.tscn")
	var skill_tree_instance = skill_tree_scene.instantiate()  # Correct method for Godot 4

	# Pass the player reference to the skill tree
	skill_tree_instance.set_player(self)
	
	get_tree().current_scene.add_child(skill_tree_instance)

func upgrade_skill(skill_name: String):
	if skill_tree.has(skill_name):
		var skill = skill_tree[skill_name]
		if skill["level"] < skill["max_level"] and skill_points > 0:
			skill["level"] += 1
			skill_points -= 1
			apply_skill_upgrades()
			
			# Update the skill points label when a skill is upgraded
			skill_points_label.text = "Skill Points: %d" % skill_points
			
			 # Update global player stats based on the skill upgraded
			if skill_name == "speed":
				GlobalStats.update_player_stat("speed", move_speed)
			elif skill_name == "jump":
				GlobalStats.update_player_stat("jump", jump_force)
			elif skill_name == "attack":
				GlobalStats.update_player_stat("attack", attack_power)
			elif skill_name == "health":
				GlobalStats.update_player_stat("health", current_health)

			#print("%s upgraded to level %d" % [skill_name, skill["level"]])
			
			print("%s upgraded to level %d" % [skill_name, skill["level"]])
		else:
			print("Cannot upgrade %s, max level reached or no skill points." % skill_name)

func apply_skill_upgrades():
	move_speed = skill_tree["speed"]["base_value"] + skill_tree["speed"]["increase_per_level"] * skill_tree["speed"]["level"]
	# dash_duration = skill_tree["dash"]["base_value"] + skill_tree["dash"]["increase_per_level"] * skill_tree["dash"]["level"]
	jump_force = skill_tree["jump"]["base_value"] + skill_tree["jump"]["increase_per_level"] * skill_tree["jump"]["level"]
	#health = skill_tree["health"]["base_value"] + skill_tree["health"]["increase_per_level"] * skill_tree["health"]["level"]
	#attack = skill_tree["attack"]["base_value"] + skill_tree["attack"]["increase_per_level"] * skill_tree["attack"]["level"]

func debug_player_stats():
	print("=== Player Stats ===")
	print("Move Speed: ", move_speed)
	print("Dash Speed: ", dash_speed)
	print("Dash Duration: ", dash_duration)
	print("Is Dashing: ", is_dashing)
	print("Jump Force: ", jump_force)
	print("Skill Points: ", skill_points)
	print("Skill Levels:")
	for skill_name in skill_tree.keys():
		print("  ", skill_name, ": Level ", skill_tree[skill_name]["level"], "/", skill_tree[skill_name]["max_level"])
	print("====================")
