extends CharacterBody3D

signal died

var health = 3
var SPEED = randf_range(2.0, 4.0)
var chase_player = false

@export var barricade: Node3D = null
@onready var bat_model = %bat_model
@onready var player = get_node("/root/Game/Player")
@onready var timer: Timer = $Timer
@onready var hurt_sound = %HurtSound
@onready var ko_sound = $KOSound
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	add_to_group("mobs")

func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	direction.y = 0.0
	bat_model.rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP) + PI
	var current_location = global_transform.origin
	if not chase_player and (barricade == null or barricade.broken):
		chase_player = true
	if chase_player:
		nav_agent.target_position = player.global_position
	else:
		nav_agent.target_position = barricade.global_position
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	velocity = velocity.move_toward(new_velocity, .25)
	move_and_slide()
	
func take_damage():
	if health == 0:
		return
		
	bat_model.hurt()
	health -= 1
	hurt_sound.play()
	
	if health == 0:
		set_physics_process(false)
		%CollisionShape3D.disabled = true
		died.emit()
		ko_sound.play()
		timer.start()

func _on_timer_timeout() -> void:
	queue_free()
