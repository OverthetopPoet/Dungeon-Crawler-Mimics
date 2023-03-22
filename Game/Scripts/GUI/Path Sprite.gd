extends Node2D

export(String, "Ranger", "Sorceress", "Warrior", "Boss", "Mummy") onready var sprite_type
export(float) onready var custom_offset

onready var pathFollowNode : PathFollow2D
var direction := 1
var timer = 0


func _ready():
	if sprite_type == "Ranger":
		$Path2D/PathFollow2D/AnimatedSprite.frames = load("res://Resources/NPCs/Main_Screen/Ranger.tres")
	elif sprite_type == "Sorceress":
		$Path2D/PathFollow2D/AnimatedSprite.frames = load("res://Resources/NPCs/Main_Screen/Sorceress.tres")
	elif sprite_type == "Warrior":
		$Path2D/PathFollow2D/AnimatedSprite.frames = load("res://Resources/NPCs/Main_Screen/Warrior.tres")	
	elif sprite_type == "Mummy":
		$Path2D/PathFollow2D/AnimatedSprite.frames = load("res://Resources/NPCs/Main_Screen/Mummy.tres")
	pathFollowNode = $Path2D/PathFollow2D
	pathFollowNode.unit_offset = 0.001


func _process(delta):	
	timer += delta
	if timer > custom_offset:
		if pathFollowNode.unit_offset == 1 || pathFollowNode.unit_offset == 0:
			direction *= -1
			if $Path2D/PathFollow2D/AnimatedSprite.flip_h == false:
				$Path2D/PathFollow2D/AnimatedSprite.flip_h = true
			else:
				$Path2D/PathFollow2D/AnimatedSprite.flip_h = false
		pathFollowNode.set_offset((pathFollowNode.get_offset() + 200 * delta * direction))
	
