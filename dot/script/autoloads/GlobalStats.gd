extends Node

# This dictionary stores the player's abilities
var player_stats = {
	"speed": 10.0,
	"jump": 20.0,
	"attack": 15.0,
	"health": 100.0
}

# Signal to notify when player stats are updated
signal player_stats_updated

# Function to update player stats and emit a signal
func update_player_stat(stat_name: String, value: float):
	if player_stats.has(stat_name):
		player_stats[stat_name] = value
		emit_signal("player_stats_updated")
