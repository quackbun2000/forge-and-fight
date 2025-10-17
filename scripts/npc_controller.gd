extends Sprite2D
class_name NPCController

var item_requirement : Item = null

@export var requirement_sprite : Sprite2D
@export var bubble : Sprite2D

func check_requirement_need(item : Item) -> bool:
	return item_requirement == item
	

func show_bubble(show : bool) -> void:
	bubble.visible = show
	requirement_sprite.texture = item_requirement.item_image
