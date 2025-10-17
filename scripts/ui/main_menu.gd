extends Control
class_name MainMenu

@onready var how_to_play_menu: TextureRect = $HowToPlayMenu

func _ready() -> void:
	how_to_play_menu.hide()

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_how_to_play_button_pressed() -> void:
	how_to_play_menu.show()

func _on_home_button_pressed() -> void:
	how_to_play_menu.hide()
