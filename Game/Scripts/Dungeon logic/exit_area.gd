extends Node2D


func _ready():
	EventManager.connect("prompt_level_exit", self, "_on_level_exit")


func _on_level_exit():
	EventManager.emit_signal("toggle_exit_level_screen")
