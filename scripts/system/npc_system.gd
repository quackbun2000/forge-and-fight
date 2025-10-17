extends Node
class_name NPCSystem

@export_group("Data")
@export var npc_prefab : PackedScene
@export var npc_list : Array[NPC]

@export_group("Setup")
@export var timer : Timer
@export var start_pos : Marker2D
@export var end_pos : Marker2D

var current_npc : NPCController = null

func spawn_npc() -> void:
	if current_npc != null: return
	var npc_to_spawn = npc_list[randi_range(0, npc_list.size() - 1)]
	
	current_npc = npc_prefab.instantiate() as NPCController

	current_npc.item_requirement = npc_to_spawn.npc_need
	current_npc.texture = npc_to_spawn.npc_image
	current_npc.global_position = start_pos.global_position
	
	add_child(current_npc)
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(current_npc, "position", end_pos.position, 1)
	tween.tween_callback(func(): current_npc.show_bubble(true))
	
	print("Spawn npc: " + npc_to_spawn.npc_name)


func remove_npc() -> void:
	if(current_npc != null):
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(current_npc, "position", start_pos.position, 1)
		tween.tween_callback(func(): 
			current_npc.queue_free()
			current_npc = null)
		timer.start(2)
		current_npc.show_bubble(false)
		print("Start timer")


func _on_timer_timeout() -> void:
	spawn_npc()
