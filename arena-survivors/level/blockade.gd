extends Area3D

var player_in_range = false

func _process(delta: float) -> void:
	if player_in_range:
		if Input.is_action_pressed("use"):
			%Player.get_node("ClearMessage").visible = false
			queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		player_in_range = true
		body.get_node("ClearMessage").visible = true

func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		player_in_range = false
		body.get_node("ClearMessage").visible = false
