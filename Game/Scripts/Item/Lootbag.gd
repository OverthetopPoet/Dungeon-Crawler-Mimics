extends Area2D

class_name lootBag

var lootBagIcon = preload ("res://Assets/Items/lootbag.png")
var invResource = preload ("res://Resources/Inventories/Player_Inventory.tres")
var lootItem = Item.new()
var lootAmount
var bagColShape = CollisionShape2D.new()
var bagRectangle = RectangleShape2D.new()
var bagSprite = Sprite.new()


func _init(position : Vector2, item : Item, amount : int):
	lootItem = item
	lootAmount = amount
	item.amount = amount
	self.position = position
	set_collision_layer(0b00000000000100000000)
	set_collision_mask(0b00000000000000000100)
	bagRectangle.extents.x = 8
	bagRectangle.extents.y = 8
	bagColShape.shape = bagRectangle
	add_child(bagColShape)
	bagSprite.texture = lootBagIcon
	add_child(bagSprite)
	connect("body_entered", self, "_on_body_entered")
	
	
func _on_body_entered(body):
	if lootItem.name == "Gold":
		EventManager.emit_signal("gold_collected", lootAmount)
		queue_free()
	else:
		if(invResource.invspacecheck() != -1):
			EventManager.emit_signal("item_collected", lootItem)	
			queue_free()

	

