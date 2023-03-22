extends AnimatedSprite

class_name npc

export(Resource) var npc_dialogue = npc_dialogue as dialogue


func _ready():
	EventManager.connect("initiate_dialogue", self, "_on_initiate_dialogue")


func _process(delta):
	if !$RayCast2D.is_colliding():
		if flip_h == true:
			flip_h = false
		else:
			flip_h = true
		$RayCast2D.rotation_degrees += 180


func _on_Area2D_body_entered(body):
	EventManager.emit_signal("trader_area_entered", position)


func _on_Area2D_body_exited(body):
	EventManager.emit_signal("trader_area_exited")


func _on_initiate_dialogue():
	EventManager.emit_signal("start_dialogue", npc_dialogue)

