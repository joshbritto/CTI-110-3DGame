extends Area3D

@export var broken = false
@onready var timer: Timer = $Timer
const MAXHEALTH = 5
var health = MAXHEALTH
var mobs_in_range = 0
var player_in_range = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("use") and player_in_range:
		if health == MAXHEALTH:
			return
		get_node("PlankMesh" + str(health+1)).visible = true
		get_node("/root/Game").increase_score(10)
		health += 1
		broken = false
		%CollisionField.disabled = false

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		player_in_range = true
		body.get_node("UseMessage").visible = true
		body.get_node("UseMessage").text = "Hold F to Rebuild Barrier"
	elif body.is_in_group("mobs"):
		mobs_in_range += 1
		if health > 0 and timer.is_stopped():
			timer.start()

func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		player_in_range = false
		body.get_node("UseMessage").visible = false
	elif body.is_in_group("mobs"):
		mobs_in_range -= 1
		if mobs_in_range <= 0:
			timer.stop()

func _on_timer_timeout() -> void:
	if health <= 0:
		%CollisionField.disabled = true
		broken = true
		return
	health -= 1
	get_node("PlankMesh" + str(health+1)).visible = false
