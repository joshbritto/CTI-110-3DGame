extends Area3D

var player_in_range = false

func _process(delta: float) -> void:
	if player_in_range:
		if Input.is_action_pressed("use"):
			%Player.get_node("UseMessage").visible = false
			queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		player_in_range = true
		body.get_node("UseMessage").visible = true
		body.get_node("UseMessage").text = "Hold F to Clear Debris"

func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		player_in_range = false
		body.get_node("UseMessage").visible = false
