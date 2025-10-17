extends Node

const save_location : String = "user://SaveData.tres"

var save_resource : SaveResource = SaveResource.new()


func _ready() -> void:
	load_data()


func save_data() -> void:
	ResourceSaver.save(save_resource, save_location)
	

func load_data() -> void:
	if FileAccess.file_exists(save_location):
		save_resource = ResourceLoader.load(save_location).duplicate(true)
