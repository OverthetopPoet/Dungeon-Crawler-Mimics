extends "res://Scripts/Item/BP_Item.gd"

class_name Wearable_Item

export(String, "Warrior", "Sorceress", "Ranger") var class_restriction
export(int) var damage
export(int) var armor
export(String) var elemental_type
export(String) var effect


func _ready():
	type = "Wearable"
	stackable = false
	


