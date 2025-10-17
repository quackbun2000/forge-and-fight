extends Button
class_name ForgeItemButton

signal item_changed(item: Inventory)

@export_category("Data")
@export var default_item : Inventory

@export_category("Setup")
@export var popup : ItemPopUp

var item : Inventory

func _ready() -> void:
	item = default_item
	icon = item.inventory_image
	pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	popup.popup()
	popup.current_item_button = self


func set_item(item : Inventory) -> void:
	self.item = item
	icon = self.item.inventory_image
	item_changed.emit(item)


func reset_to_default_item() -> void:
	set_item(default_item)
