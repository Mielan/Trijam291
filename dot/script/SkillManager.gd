extends Node

# Variables to store skill levels
var speed_level = 1  # Initial level
var jump_level = 1  # Initial level
var attack_level = 1  # Initial level

# Function to increase skill level
func increase_speed():
	speed_level += 1

func increase_jump():
	jump_level += 1

func increase_attack():
	attack_level += 1

# Function to apply skill multipliers to entities (player or enemy)
func apply_skills_to_entity(entity, base_speed, base_jump, base_attack):
	entity.speed = base_speed * speed_level
	entity.jump_strength = base_jump * jump_level
	entity.attack_power = base_attack * attack_level
