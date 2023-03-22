extends Area2D


func _on_Exit_Area_body_entered(body):
	if body is playable_Character_Tavern:
		EventManager.emit_signal("enter_dungeon")

