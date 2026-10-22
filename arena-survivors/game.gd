extends Node3D

var player_score = 0
@onready var label = %Label
@onready var player: CharacterBody3D = %Player

func increase_score():
	player_score += 1
	label.text = "Score: " + str(player_score)
	
func do_poof(mob_global_position):
	const SMOKE_PUFF = preload("uid://cjk3frr43yesb")
	var poof = SMOKE_PUFF.instantiate()
	add_child(poof)
	poof.global_position = mob_global_position
	
func _on_mob_spawner_3d_mob_spawned(mob, barricade):
	mob.died.connect(func on_mob_died():
		increase_score()
		do_poof(mob.global_position)
	)
	do_poof(mob.global_position)
	if barricade:
		mob.barricade = barricade

func _on_kill_plane_body_entered(body):
	get_tree().reload_current_scene.call_deferred()
