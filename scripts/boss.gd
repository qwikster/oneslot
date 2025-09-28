extends Area2D
class_name Boss

@export var boss_name: String = "boss1"
@export var sprite_texture: Texture2D

func _ready() -> void:
	# Apply the chosen sprite
	if sprite_texture:
		$Sprite2D.texture = sprite_texture

	# Connect overlap
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	# Ensure only the Player node triggers this
	if body.name == "Player":  # assumes your player scene root node is named "Player"
		var popup = get_tree().root.get_node("Main/Dialogue")
		if popup:
			popup.start_boss_encounter(boss_name)
			queue_free()
		else:
			push_error("Popup node not found in scene tree.")
