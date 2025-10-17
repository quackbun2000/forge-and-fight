extends Control

@onready var day_text: Label = $Background/GridContainer/DayText
@onready var highest_day_text: Label = $Background/GridContainer/HighestDayText
@onready var earned_text: Label = $Background/GridContainer/EarnedText
@onready var highest_earned_text: Label = $Background/GridContainer/HighestEarnedText
@onready var money_highscore_box: ColorRect = $Background/MoneyHighscoreBox
@onready var day_highscore_box: ColorRect = $Background/DayHighscoreBox

func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_replay_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_level_manager_state_change(state: LevelManager.GameState) -> void:
	if state == LevelManager.GameState.OVER:
		
		if Global.level_manager.current_level > SaveSystem.save_resource.highest_day:
			SaveSystem.save_resource.highest_day = Global.level_manager.current_level
			SaveSystem.save_data()
			day_highscore_box.show()
		else:
			day_highscore_box.hide()
			
		if Global.level_manager.highest_money > SaveSystem.save_resource.highest_money:
			SaveSystem.save_resource.highest_money = Global.level_manager.highest_money
			SaveSystem.save_data()
			money_highscore_box.show()
		else:
			money_highscore_box.hide()
		
		_update_score_text()
		
		show()


func _update_score_text() -> void:
	day_text.text = str(Global.level_manager.current_level)
	highest_day_text.text = str(SaveSystem.save_resource.highest_day)
	earned_text.text = str(Global.level_manager.highest_money)
	highest_earned_text.text = str(SaveSystem.save_resource.highest_money)
	
	
