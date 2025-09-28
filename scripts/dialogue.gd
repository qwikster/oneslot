extends CanvasLayer

var index: int = 0
var awaiting_input: bool = false
var current_boss: String = ""

# Dialogue data for all five bosses
# Each boss has a list of dicts
# Dict keys: "speaker", "text", optional "choices"
# "choices" is array of dicts { "text": String, "next": int }
var dialogues := {
	"boss1": [
		{ "speaker": "Ares", "text": "You dare enter my domain, mortal?" },
		{ "speaker": "Ares", "text": "Do you carry the Sword of Truth?",
		  "choices": [
			  { "text": "Yes, I wield it!", "next": 2 },
			  { "text": "No...", "next": 3 }
		  ]
		},
		{ "speaker": "Ares", "text": "crash"},
		{ "speaker": "Ares", "text": "Without it, you are nothing." }
	],
	"boss2": [
		{ "speaker": "Nyx", "text": "The shadows whisper your fate." },
		{ "speaker": "Nyx", "text": "Only the Shield of Hope protects from eternal night." },
		{ "speaker": "Nyx", "text": "Do you stand ready?" }
	],
	"boss3": [
		{ "speaker": "Kronos", "text": "Time bends to my will." },
		{ "speaker": "Kronos", "text": "Show me your Amulet of Despair!",
		  "choices": [
			  { "text": "I have it.", "next": 2 },
			  { "text": "I do not.", "next": 3 }
		  ]
		},
		{ "speaker": "Kronos", "text": "Then your fate is sealed." },
		{ "speaker": "Kronos", "text": "Pathetic. Die now." }
	],
	"boss4": [
		{ "speaker": "Helios", "text": "The sun burns away all lies." },
		{ "speaker": "Helios", "text": "But you brought the wrong relic. This world ends now." }
	],
	"boss5": [
		{ "speaker": "Thanatos", "text": "Death waits for none." },
		{ "speaker": "Thanatos", "text": "The items you bear are worthless against me." }
	]
}

var boss_requirements := {
	"boss1": ["sword_of_truth"],
	"boss2": ["shield_of_hope"],
	"boss3": ["amulet_of_despair"],
	"boss4": ["invalid_item"],
	"boss5": ["invalid_item"]
}

func _ready() -> void:
	set_process_unhandled_input(true)
	$Speaker.hide()
	$Text.hide()
	$Choices.hide()
	start_boss_encounter("boss1")

func start_boss_encounter(boss_name: String):
	var required = boss_requirements[boss_name]
	var valid = false
	for item in required:
		if Inventory.has_item(item):
			valid = true
			break

	if not valid:
		push_error("Wrong item used against %s → intentional crash" % boss_name)
		# OS.crash("dumbas")

	current_boss = boss_name
	index = 0
	show_next_line()

func show_next_line():
	var lines = dialogues[current_boss]
	if index >= lines.size():
		end_dialog()
		return

	var line = lines[index]
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

	$Speaker/Label.text = speaker
	$Text/Label.text = text
	$Speaker.show()
	$Text.show()
	$Choices.show()

	for i in range($Choices.get_child_count()):
		var btn = $Choices.get_child(i)
		if i < choices.size():
			var choice = choices[i]
			btn.text = choice.text
			btn.show()

			# Disconnect old signals if already connected
			if btn.is_connected("pressed", Callable(self, "_on_choice_selected")):
				btn.disconnect("pressed", Callable(self, "_on_choice_selected"))

			# Connect and bind the index
			btn.connect("pressed", Callable(self, "_on_choice_selected").bind(choice.next))
		else:
			btn.hide()


func _on_choice_selected(next_index: int):
	$Choices.hide()
	index = next_index
	awaiting_input = true
	show_next_line()
	
	if $Text/Label.text == "crash":
		OS.crash("dumbas")

func _unhandled_input(event: InputEvent) -> void:
	if awaiting_input and event.is_action_pressed("interact"):
		show_next_line()

func end_dialog():
	$Speaker.hide()
	$Text.hide()
	$Choices.hide()
	awaiting_input = false
	print("dialog over")
