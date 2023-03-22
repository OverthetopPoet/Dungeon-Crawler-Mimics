extends CenterContainer
class_name InventorySlot

var inventory : Inventory
var texture_rect : TextureRect
var stackLabel : RichTextLabel
var format_string = "[b]%s[/b]"
var num_string : String


func _init(Inventory):
	inventory = Inventory
	size_flags_horizontal = SIZE_EXPAND_FILL
	size_flags_vertical = SIZE_EXPAND_FILL
	texture_rect = TextureRect.new()
	stackLabel = RichTextLabel.new()
	stackLabel.bbcode_enabled = true
	stackLabel.rect_size.x = 16
	stackLabel.rect_size.y = 16
	stackLabel.rect_scale.x = 0.8
	stackLabel.rect_scale.y = 0.8
	stackLabel.anchor_left = 0.6
	stackLabel.anchor_top = 0.425
	stackLabel.anchor_right = 0.738
	stackLabel.anchor_bottom = 0.433
	stackLabel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	stackLabel.set("custom_colors/font_color_shadow", Color(0,0,0))
	stackLabel.bbcode_text = ""
	texture_rect.add_child(stackLabel)
	add_child(texture_rect)
	
	
func display(item:Item):
	if item is Item:		
		texture_rect.texture = item.icon
		if "amount" in item:
			num_string = str(item.amount)
			stackLabel.bbcode_text = format_string % num_string
		else:
			stackLabel.bbcode_text = ""
	else:
		texture_rect.texture = null
		stackLabel.bbcode_text = ""


func get_drag_data(_position):
	var item_index = get_index()
	var item : Item = inventory.remove_item(item_index)
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		var drag_preview = TextureRect.new()
		drag_preview.texture = item.icon
		drag_preview.rect_scale = Vector2(3, 3)
		set_drag_preview(drag_preview)
		return data
	
	
func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
	
func drop_data(_position, data):
	var my_item_index = get_index()
	var my_item = inventory.items[my_item_index]
	if my_item is Item and my_item.name == data.item.name and "amount" in my_item:
		my_item.amount += data.item.amount
		display(my_item)
	else:
		inventory.swap_item(my_item_index,data.item_index)
		inventory.set_item(my_item_index,data.item)
