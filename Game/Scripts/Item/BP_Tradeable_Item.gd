extends "res://Scripts/Item/BP_Item.gd"

class_name Tradeable_Item

export(int) var amount


func _ready():
	type = "Tradeable"
	stackable = true



