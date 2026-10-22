extends Node3D

signal mob_spawned(mob)

@export var mob_to_spawn: PackedScene = null
@export var barricade: Node3D = null
@onready var timer = %Timer
@onready var marker_3d = %Marker3D

func _on_timer_timeout():
	var new_mob = mob_to_spawn.instantiate()
	add_child(new_mob)
	new_mob.global_position = marker_3d.global_position
	mob_spawned.emit(new_mob, barricade)
