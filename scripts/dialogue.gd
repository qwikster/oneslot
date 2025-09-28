extends CanvasLayer

var index: int = 0
var awaiting_input: bool = false
var current_dialogue: String = ""
signal dialogue_over(boss_name: String)
var current_boss: String = ""

var dialogues := {
	"boss1_success": [
		{ "speaker": "Robot", "text": "You notice a rusty robot blocking the way." },
		{ "speaker": "Robot", "text": "It guards the path onwards; it must be sacrificed." },
		{ "speaker": "Robot", "text": "You strike the robot as it runs towards you." },
		{ "speaker": "Robot", "text": "Finish it, or move forward?",
		  "choices": [
			  { "text": "Finish", "next": 4 },
			  { "text": "Forward", "next": 5 }
		  ]
		},
		{ "speaker": "Robot", "text": "The robot's eyes darken, lifeless." },
		{ "speaker": "Robot", "text": "The robot's eyes dim, a broken heap." }
	],
	"boss1_fail": [
		{ "speaker": "Robot", "text": "What made you think a spoon would help?" },
		{ "speaker": "Robot", "text": "crash" }
	],

	"boss2_success": [
		{ "speaker": "Sentinel", "text": "A toaster-looking robot blocks the way." },
		{ "speaker": "Sentinel", "text": "Can it toast bread? No." },
		{ "speaker": "Sentinel", "text": "You attack and it short-circuits." },
		{ "speaker": "Sentinel", "text": "\"COVENANT MEMBER LOST ??!?!?" },
		{ "speaker": "Sentinel", "text": "It still doesn't toast bread." },
		{ "speaker": "Sentinel", "text": "Metal pipe sound effect." }
	],
	"boss2_fail": [
		{ "speaker": "Sentinel", "text": "Metal pipe sound effect" },
		{ "speaker": "Sentinel", "text": "crash" }
	],

	"boss3_success": [
		{ "speaker": "Senator", "text": "\"Nanomachines, son\"" },
		{ "speaker": "Senator", "text": "This isn't Metal Gear, but close enough." },
		{ "speaker": "Senator", "text": "\"Played college ball, you know\"" },
		{ "speaker": "Senator", "text": "\"Try University of Texas\"" },
		{ "speaker": "Senator", "text": "You attack and he falls easily." }
	],
	"boss3_fail": [
		{ "speaker": "Senator", "text": "gooner" },
		{ "speaker": "Senator", "text": "crash" }
	],

	"boss4_success": [
		{ "speaker": "Conduit", "text": "It's just a heap of metal conduit." },
		{ "speaker": "Conduit", "text": "You cut it out of your way." },
		{ "speaker": "Conduit", "text": "That was easy. Wow." }
	],
	"boss4_fail": [
		{ "speaker": "Conduit", "text": "why did you think that would help" },
		{ "speaker": "Conduit", "text": "crash" }
	],

	"boss5_fail": [
		{ "speaker": "???", "text": "So we finally meet." },
		{ "speaker": "???", "text": "AAAAAAAAAAAA" },
		{ "speaker": "???", "text": "The information leaks further." },
		{ "speaker": "???", "text": "I must purge it... but." },
		{ "speaker": "???", "text": "You can't save the world if you save me." },
		{ "speaker": "???", "text": "Sacrifices must be made." },
		{ "speaker": "???", "text": "Take the data. I'll watch on elsewhere.",
		  "choices": [
			  { "text": "Delete data", "next": 8 },
			  { "text": "Take data", "next": 9 }
		  ]
		},
		{ "speaker": "???", "text": "crash" },
		{ "speaker": "???", "text": "WHY WOULD YOU DO THAT" }
	],
	"boss5_success": [
		{ "speaker": "???", "text": "crash" }
	]
}


var boss_requirements := {
	"boss1": ["spoon", "remote"],
	"boss2": ["loop", "chip"],
	"boss3": ["gemchip", "ball"],
	"boss4": ["shard", "coin"], 
	"boss5": ["sdfjsdf"] # fail is normal theme
}

func _ready() -> void:
	set_process_unhandled_input(true)
	$Speaker.hide()
	$Text.hide()
	$Choices.hide()


func start_boss_encounter(boss_name: String):
	current_boss = boss_name
	var valid = false
	if boss_requirements[boss_name].has(Inventory.items):
		valid = true
	else:
		valid = false

	if valid:
		current_dialogue = boss_name + "_success"
	else:
		current_dialogue = boss_name + "_fail"

	index = 0
	show_next_line()


func show_next_line():
	var lines = dialogues[current_dialogue]   # FIXED: was current_boss
	if index >= lines.size():
		end_dialog()
		return

	var line = lines[index]

	# Handle "crash" as a command, not text
	if line.has("text") and line.text == "crash":
		OS.crash("Dialogue-triggered crash")
		return

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

			# Avoid duplicate connections
			if btn.is_connected("pressed", Callable(self, "_on_choice_selected")):
				btn.disconnect("pressed", Callable(self, "_on_choice_selected"))

			btn.connect("pressed", Callable(self, "_on_choice_selected").bind(choice.next))
		else:
			btn.hide()


func _on_choice_selected(next_index: int):
	$Choices.hide()
	index = next_index
	awaiting_input = true
	show_next_line()


func _unhandled_input(event: InputEvent) -> void:
	if awaiting_input and event.is_action_pressed("interact"):
		show_next_line()


func end_dialog():
	$Speaker.hide()
	$Text.hide()
	$Choices.hide()
	awaiting_input = false
	print("dialog over")
