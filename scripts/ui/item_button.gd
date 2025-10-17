extends Button
class_name ItemButton

signal change_item(item : Inventory)

@export_category("Data")
@export var inventory : Inventory

@export_category("Setup")
@export var popup : PopupPanel 

func _ready() -> void:
	icon = inventory.inventory_image
	pressed.connect(_on_item_button_pressed)


func _on_item_button_pressed() -> void:
	change_item.emit(inventory)
