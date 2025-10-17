extends Resource
class_name Inventory

enum InventoryType {
	NONE = 0,
	BROOM = 1,
	FORK = 2,
	MUSHROOM = 3,
	BOWL = 4
}

@export_category("Data")
@export var inventory_type : InventoryType
@export var inventory_image : Texture2D
