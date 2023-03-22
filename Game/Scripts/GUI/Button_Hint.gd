extends AnimatedSprite

func _ready():
	EventManager.connect("trader_area_entered", self, "_on_trader_area_entered")
	EventManager.connect("trader_area_exited", self, "_on_trader_area_exited")
	EventManager.connect("chest_area_entered", self, "_on_trader_area_entered")
	EventManager.connect("chest_area_exited", self, "_on_trader_area_exited")


func _on_trader_area_entered(pos):
	visible = true
	position = pos
	position.y -= 18
	
	
func _on_trader_area_exited():
	visible = false
