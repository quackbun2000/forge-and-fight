extends Control
class_name InGameUI

@onready var timer_text: Label = $Timer/TimerText

@export var recipe_popup : PopupPanel


func _process(delta: float) -> void:
	_update_timer()


func _update_timer() -> void:
	timer_text.text = str("%0.2f" % Global.level_manager.level_timer.time_left)


func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_level_manager_state_change(state: LevelManager.GameState) -> void:
	if state == LevelManager.GameState.OVER:
		hide()


func _on_recipe_book_button_pressed() -> void:
	recipe_popup.show()


func _on_close_button_pressed() -> void:
	recipe_popup.hide()
