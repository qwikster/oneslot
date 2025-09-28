extends Area2D

@export var item_name: String = "unknown_item"    # internal ID
@export var display_name: String = "Mystery Item" # what player sees
@export var item_texture: Texture2D               # drop-in sprite

func _ready() -> void:
	# set sprite from exported texture
	if $Sprite2D and item_texture:
		$Sprite2D.texture = item_texture

	# set floating label text
	if $Label:
		$Label.text = display_name

	connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player": # or body.is_in_group("player")
		var ui = get_tree().root.get_node("Main/UI") # adjust if path differs
		ui.show_popup("Pick up %s?" % $Label.text, self)

func on_choice_made(taken: bool) -> void:
	if taken:
		print("Player took %s" % item_name)
		queue_free()
	else:
		print("Player ignored %s" % item_name)
