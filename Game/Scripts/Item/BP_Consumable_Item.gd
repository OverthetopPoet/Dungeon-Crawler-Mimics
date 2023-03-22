extends "res://Scripts/Item/BP_Item.gd"

class_name Consumable_Item

export(int) var damage
export(int) var healing
export(int) var amount
export(String) var effect


func _ready():
	type = "Consumable"
	stackable = true
	

