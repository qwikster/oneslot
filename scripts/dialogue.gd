extends CanvasLayer

var current_item: Node = null
var awaiting_input: bool = false

var dialog = [
	{"speaker": "fily", "text": "ORIN FILL THIS OUT THANKS"},
	{"speaker": "fily", "text": "(i cant do story lol)"}
]
var index = 0

func _ready() -> void:
	set_process_unhandled_input(true)
	$Speaker.hide()
	$Text.hide()
	start_dialog()

func start_dialog() -> void:
	index = 0
	awaiting_input = true
	show_next_line()

func show_next_line() -> void:
	if index < dialog.size():
		var line = dialog[index]
		show_dialog(line.speaker, line.text)
		index += 1
	else:
		hide_dialog()
		awaiting_input = false

func show_dialog(speaker: String, _text: String) -> void:
	print(speaker, _text)
	$Speaker/Label.text = speaker
	$Text/Label.text = _text
	$Speaker.show()
	$Text.show()

func hide_dialog() -> void:
	$Speaker.hide()
	$Text.hide()

func _unhandled_input(event: InputEvent) -> void:
	if not awaiting_input:
		return
	if event.is_action_pressed("interact"):
		show_next_line()
