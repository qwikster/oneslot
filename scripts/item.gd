extends Area2D

@export var item_name: String = "unknown_item"
@export var display_name: String = "Mystery Item"
@export var item_texture: Texture2D

func _ready() -> void:
	if $Sprite2D and item_texture:
		$Sprite2D.texture = item_texture

	if $Label:
		$Label.text = display_name

	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		var ui = get_tree().root.get_node("Main/UI")
		ui.show_popup("Pick up %s?" % $Label.text, self)

func on_choice_made(taken: bool) -> void:
	if taken:
		print("Player took %s" % item_name)
		queue_free()
	else:
		print("Player ignored %s" % item_name)
