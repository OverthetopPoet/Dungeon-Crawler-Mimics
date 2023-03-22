extends Resource
class_name Inventory

export(Array,Resource) var items = [null]
export(int) var inventorysize;


func set_item(index : int,item : Item) -> Item:
	var previous = items[index]
	items[index] = item
	EventManager.emit_signal("items_changed",[index])
	return previous
	
	
func remove_item(index:int) -> Item:
	var previous = items[index]
	items[index] = null
	if previous!=null:
		EventManager.emit_signal("items_changed",[index])
	return previous


func swap_item(index_old:int, index_new:int):
	var targetItem = items[index_new]
	var oldItem = items[index_old]
	items[index_old] = targetItem
	items[index_new] = oldItem
	EventManager.emit_signal("items_changed",[index_old,index_new])
	
	
func clear_inventory():
	for index in range(0,items.size()):
		remove_item(index)
		
		
func invspacecheck():
	var invsize = items.size() - 1
	var invpointer = 0
	for entry in items:
		if entry == null:
			return invpointer
		if invpointer == invsize:
			return -1
		invpointer = invpointer + 1


func _on_item_collected(item):
	var freeinvspace = invspacecheck()
	if freeinvspace != -1:
		items[freeinvspace] = item
		EventManager.emit_signal("items_changed",[freeinvspace])
	
	
func _init():
	EventManager.connect("item_collected", self, "_on_item_collected")
