extends Node2D

class_name tavern

var character_scene = preload("res://Scenes/Character/CharacterTavern.tscn")

func init(current_character : character):
	var character_instance = character_scene.instance()
	character_instance.characterName = current_character.characterName
	add_child(character_instance)
	character_instance.position = Vector2(250,56)
	

func _on_Exit_Area_body_entered(body):
	queue_free()
	EventManager.emit_signal("enter_dungeon")
	

