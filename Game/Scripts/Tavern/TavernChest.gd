extends Sprite

var openable=false
var open=false


func _process(delta):
	if openable and Input.is_action_just_pressed("interact"):
		open=!open
		if open:
			region_rect.position.x+=16
		else:
			region_rect.position.x-=16


func _on_Area2D_body_entered(body):
	openable=true
	EventManager.emit_signal("chest_area_entered", position)


func _on_Area2D_body_exited(body):
	openable=false
	if open:
		open=false
		region_rect.position.x-=16
	EventManager.emit_signal("chest_area_exited")


		
		
