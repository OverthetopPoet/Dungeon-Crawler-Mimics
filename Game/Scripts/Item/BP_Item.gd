extends Resource

class_name Item

export(String) var name
export(String, MULTILINE) var itemDescription
export(String, "Consumable", "Tradeable", "Wearable") var type
export(Texture) var icon
export(Shape2D) var itemCollisionShape = itemCollisionShape as Shape 
export(int) var value
export(bool) var stackable


