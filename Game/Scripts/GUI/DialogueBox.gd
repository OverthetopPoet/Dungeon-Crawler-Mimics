extends TextureRect

var current_slide_index = 0


func _ready():
	EventManager.connect("start_dialogue", self, "_on_start_dialogue")
	EventManager.connect("trader_area_exited", self, "_on_trader_area_exited")


func _process(delta):
	if Input.is_action_just_pressed("interact"):
		current_slide_index += 1


func _on_start_dialogue(_dialogue):
	if current_slide_index < _dialogue.dialogue_text.size() and _dialogue != null:
		visible = true
		get_node("Label").text = _dialogue.dialogue_text[current_slide_index]
	else:
		visible = false
		current_slide_index = -1
		
		
func _on_trader_area_exited():
	visible = false
	current_slide_index = -1
