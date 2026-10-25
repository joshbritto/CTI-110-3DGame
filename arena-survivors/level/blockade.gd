extends Area3D

@export var mob_spawner: Node3D = null
@export var cost: int = 0
var player_in_range = false

func _process(delta: float) -> void:
	if player_in_range:
		if Input.is_action_pressed("use"):
			var game = get_node("/root/Game")
			if game.player_score >= cost:
				%Player.get_node("UseMessage").visible = false
				if mob_spawner:
					mob_spawner.active = true
				game.increase_score(-cost)
				queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		player_in_range = true
		body.get_node("UseMessage").visible = true
		body.get_node("UseMessage").text = "Hold F to Clear Debris [Cost: " + str(cost) + "]"

func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		player_in_range = false
		body.get_node("UseMessage").visible = false
