extends Area2D

var interactable=false
var interactable_object	


func _process(delta):
	if interactable and Input.is_action_just_pressed("interact"):
		if interactable_object["type"] == "exit":
			EventManager.emit_signal("prompt_level_exit")
		else:
			EventManager.emit_signal("interacted_with_object", interactable_object)
			queue_free()


func _on_interaction_area_body_entered(body):
	if body is playable_Character:
		interactable=true


func _on_interaction_area_body_exited(body):
	if body is playable_Character:
		interactable=false
