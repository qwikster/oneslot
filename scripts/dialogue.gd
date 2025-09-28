extends CanvasLayer

var dialog = [
  {
	"speaker": "fily",
	"text": "ORIN FILL THIS OUT THANKS"
  },
  {
	"speaker": "fily",
	"text": "(i cant do story lol)",
	"choices": [
	  { "text": "click me", "next": 2 },
	  { "text": "queue tetra league", "next": 3 },
	]
  },
  {
	"speaker": "orin",
	"text": "shit"
  },
{
	"speaker": "ricky",
	"text": "i use windows btw"
}
]


var index := 0
var awaiting_input := false

func _ready() -> void:
	set_process_unhandled_input(true)
	$Speaker.hide()
	$Text.hide()
	$Choices.hide()
	start_dialog()

func start_dialog():
	index = 0
	awaiting_input = true
	show_next_line()

func show_next_line():
	if index >= dialog.size():
		end_dialog()
		return

	var line = dialog[index]

	if line.has("choices"):
		show_choices(line)
	else:
		show_dialog(line.speaker, line.text)
		index += 1

func show_dialog(speaker: String, text: String):
	awaiting_input = true
	$Speaker/Label.text = speaker
	$Text/Label.text = text
	$Speaker.show()
	$Text.show()
	$Choices.hide()

func show_choices(line: Dictionary):
	awaiting_input = false
	var speaker = line.get("speaker", "")
	var text = line.get("text", "")
	var choices = line.get("choices", [])

	# Show dialog text
	$Speaker/Label.text = speaker
	$Text/Label.text = text
	$Speaker.show()
	$Text.show()

	# Show choices
	$Choices.show()
	for i in range($Choices.get_child_count()):
		var btn = $Choices.get_child(i)
		if i < choices.size():
			var choice = choices[i]
			btn.text = choice.text
			btn.show()
			#btn.disconnect_all("pressed") # Prevent duplicate connections
			btn.connect("pressed", Callable(self, "_on_choice_selected").bind(choice.next))
		else:
			btn.hide()

func _on_choice_selected(next_index: int):
	$Choices.hide()
	#for btn in $Choices.get_children():
		#btn.disconnect_all("pressed")
	index = next_index
	awaiting_input = true
	show_next_line()

func _unhandled_input(event: InputEvent) -> void:
	if not awaiting_input:
		return
	if event.is_action_pressed("interact"):
		show_next_line()

func end_dialog():
	$Speaker.hide()
	$Text.hide()
	$Choices.hide()
	awaiting_input = false
	print("Dialog finished.")
