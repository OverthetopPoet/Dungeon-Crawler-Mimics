extends Control

var boss_killed=false


func _ready():
	EventManager.connect("toggle_exit_level_screen",self, "toggle_visibility")
	EventManager.connect("boss_killed",self,"_on_boss_killed")


func toggle_visibility():
	if boss_killed:
		if visible:
			visible=false
		else:
			visible=true


func _on_boss_killed():
	boss_killed=true


func _on_return_pressed():
	visible=false


func _on_exit_dungeon_pressed():
	visible=false
	boss_killed=false
	EventManager.emit_signal("exit_dungeon")


func _on_continue_pressed():
	visible=false
	boss_killed=false
	EventManager.emit_signal("change_level")
