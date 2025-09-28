extends CanvasLayer

var current_item: Node = null
var awaiting_input: bool = false

func _ready() -> void:
	set_process_unhandled_input(true)
	$PopupPanel.hide()

func show_popup(prompt: String, item_ref: Node) -> void:
	$PopupPanel/Label.text = "%s (Y/N)" % prompt
	current_item = item_ref
	awaiting_input = true
	$PopupPanel.show()

func _unhandled_input(event: InputEvent) -> void:
	if not awaiting_input:
		return
	if event is InputEventKey and event.pressed:
		match OS.get_keycode_string(event.keycode).to_upper():
			"Y": _choice_made(true)
			"N": _choice_made(false)

func _choice_made(taken: bool) -> void:
	awaiting_input = false
	$PopupPanel.hide()
	if current_item and current_item.has_method("on_choice_made"):
		current_item.on_choice_made(taken)
	current_item = null
