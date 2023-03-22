extends Node2D

class_name cast_skill

onready var  travel = get_node("Travel")
onready var hit = get_node("Hit")


func _init(used_skill : skill, pos):
	hit.visible = false
	travel.frames = used_skill.animation
	hit.frames = used_skill.animation_hit
	position = pos

