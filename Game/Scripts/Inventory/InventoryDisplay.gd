extends Control

export(Resource) var inventory = inventory as Inventory
export(NodePath) onready var inv_grid = get_node(inv_grid) as GridContainer
export(String) var inventory_type


func _ready():
	EventManager.connect("player_died", self, "_on_player_died")
	EventManager.connect("items_changed",self,"_on_items_changed")
	for index in inventory.items.size():
		inv_grid.add_child(InventorySlot.new(inventory))
	update_inventory_display()


func update_inventory_display():
	for item_index in inventory.items.size():
		update_inventory_slot(item_index)


func update_inventory_slot(item_index):
	var inventorySlot = inv_grid.get_child(item_index)
	var item = inventory.items[item_index]
	EventManager.emit_signal("items_changed", item_index)
	inventorySlot.display(item)


func show_tooltip(item_index):
	var tooltip = TextureRect.new()


func _on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot(item_index)
	
	
func can_drop_data(position, data):
	return data is Dictionary and data.has("item")
	
	
func drop_data(position, data):
	inventory.set_item(data.item_index,data.item)


func _on_player_died(characterClass):
	inventory.clear_inventory()
	
	
func _process(delta):
	if Input.is_action_just_pressed("OpenInv") and inventory_type=="Player":
		visible = !visible

		
