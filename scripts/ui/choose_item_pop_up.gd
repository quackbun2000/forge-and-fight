extends PopupPanel
class_name ItemPopUp

var current_item_button : ForgeItemButton

func set_current_button(button : ForgeItemButton) -> void:
	current_item_button = button


func _on_button_change_item(item: Inventory) -> void:
	if(current_item_button != null):
		var item_button : ForgeItemButton = current_item_button as ForgeItemButton
		item_button.set_item(item)
	hide()
