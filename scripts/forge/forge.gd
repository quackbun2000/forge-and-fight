extends Control
class_name Forge

@onready var item_button_1: ForgeItemButton = %ItemButton1
@onready var item_button_2: ForgeItemButton = %ItemButton2
@onready var forge_button: Button = $ForgeButton
@onready var result_texture: TextureRect = $ResultTexture
@onready var button_container: HBoxContainer = $ButtonContainer

@export_group("Effects")
@export var forge_sfx : AudioStreamPlayer
@export var forge_vfx : GPUParticles2D
@export var popup_text_prefab : PackedScene

@export_group("Setup")
@export var item_popup : ItemPopUp
@export var wrong_item : Item
@export var npc_system : NPCSystem
@export var earned_money_text: Label
@export var goal_money_text: Label
@export var day_text : Label


var result_item : Item = null

func _ready() -> void:
	_update_money_text()
	_update_goal_money_text()


func _check_for_forge() -> bool:
	return (item_button_1.item.inventory_type != Inventory.InventoryType.NONE 
		and item_button_2.item.inventory_type != Inventory.InventoryType.NONE
		and result_item == null)


func _on_item_changed(item: Inventory) -> void:
	var can_forge = _check_for_forge()
	forge_button.visible = can_forge


func forge() -> void:
	var result = craft_item([item_button_1.item, item_button_2.item])
	Global.level_manager.reduce_money(2)
	forge_sfx.play()
	forge_vfx.emitting = true
	
	if(result == null):
		print("Fail to craft the right item")
		result_item = wrong_item
		result_texture.texture = wrong_item.item_image
	else:
		print("Successfully craft " + result.item_name)
		result_item = result
		result_texture.texture = result.item_image
		
	item_button_1.reset_to_default_item()
	item_button_2.reset_to_default_item()
	
	button_container.visible = (result_item != null)
	

func craft_item(items: Array[Inventory]) -> Item:
	var result = null
	for recipe in CraftingSystem.recipes:
		if recipe.ingredients.all(func(ingredient): return ingredient in items):
			result = recipe.results
			break;
	return result
	

func discard_item() -> void:
	print("Discard item")
	result_item = null
	result_texture.texture = null
	forge_button.visible = _check_for_forge()
	button_container.visible = (result_item != null)
	
	
func send_item() -> void:
	print("Send item")
	if(npc_system.current_npc.check_requirement_need(result_item)):
		npc_system.remove_npc()
		print("Send right item")
		Global.level_manager.increase_money(10)
	else:
		Global.level_manager.reduce_money(2)
		
	result_item = null
	result_texture.texture = null
	forge_button.visible = _check_for_forge()
	button_container.visible = (result_item != null)
	

func _on_money_increase(amount: int) -> void:
	var popup_text : Label = popup_text_prefab.instantiate() as Label
	earned_money_text.add_child(popup_text)
	
	popup_text.text = "+" + str(amount)
	popup_text.set("theme_override_colors/font_color", Color.GREEN)
	popup_text.position = earned_money_text.position
	
	var tween = get_tree().create_tween()
	
	tween.tween_property(popup_text, "position", earned_money_text.position - Vector2(0, 50), 1)
	tween.tween_callback(func(): popup_text.queue_free())
	_update_money_text()


func _on_money_decrease(amount: int) -> void:
	var popup_text : Label = popup_text_prefab.instantiate() as Label
	earned_money_text.add_child(popup_text)
	
	popup_text.text = "-" + str(amount)
	popup_text.set("theme_override_colors/font_color", Color.RED)
	popup_text.position = earned_money_text.position
	
	var tween = get_tree().create_tween()
	tween.tween_property(popup_text, "position", earned_money_text.position - Vector2(0, 60), 1)
	tween.tween_callback(func(): popup_text.queue_free())
	
	_update_money_text()


func _update_money_text() -> void:
	earned_money_text.text = str(Global.level_manager.current_money_amount)


func _update_goal_money_text() -> void:
	goal_money_text.text = "Goal: " + str(Global.level_manager.goal_money) + "$"


func _update_day_text() -> void:
	day_text.text = "Day: " + str(Global.level_manager.current_level)


func _on_next_level(level : int) -> void:
	print("Go to next level")
	var popup_text : Label = popup_text_prefab.instantiate() as Label
	popup_text.text = str(level - 1) + "->" + str(level)
	popup_text.set("theme_override_colors/font_color", Color.GREEN)
	popup_text.position = day_text.position
	day_text.add_child(popup_text)
	
	var tween = get_tree().create_tween()
	tween.tween_property(popup_text, "position", day_text.position - Vector2(0, 60), 1)
	tween.tween_callback(func(): popup_text.queue_free())
	
	_update_money_text()
	_update_goal_money_text()
	_update_day_text()


func _on_level_manager_state_change(state: LevelManager.GameState) -> void:
	if state == LevelManager.GameState.OVER:
		item_popup.hide()
		hide()
