extends CharacterBody2D

func spawn_item(x, y, sprite: Texture2D, item_name: String, item_label: String):
	"""
	Instantiates an item from 'item.tscn' at a specific location.
	> x, y - Item position (no collision checks!)
	> sprite - Texture2D node path.
	> item_name - internal item name (WIP)
	> item_label - label of the item that will be shown to the player.
	"""
	var item_scene = preload("res://scenes/item.tscn")
	var item_instance = item_scene.instantiate()
	
	item_instance.position = Vector2(x, y)
	item_instance.name = item_name

	var sprite_node = item_instance.get_node("Sprite2D")
	if sprite_node and sprite is Texture2D:
		sprite_node.texture = sprite
	
	# get the label and set it as... label (lol)
	var label_node = item_instance.get_node("CanvasLayer/TextureRect/Label")
	if label_node:
		label_node.text = item_label
	
	get_tree().current_scene.add_child(item_instance)

func _ready():
	var popup_menu = $CanvasLayer/Window/Popup/PopupMenu
	if popup_menu:
		popup_menu.id_pressed.connect(_on_popup_id_pressed)
	else:
		print("idiot (popupmenu)")

	var popup_container = $CanvasLayer/Window/Popup
	if popup_container:
		popup_container.hide()

func _show_popup(prompt: String, pos_rel: String, options: Array[String]):
	"""
	Shows a pop-up on the screen with a prompt and a list of options.
	> prompt - The question to ask the player (e.g., "Pick up the sword?").
	> pos_rel - Sets a relative position (center, rcenter, lcenter, rtop, ltop, lbot, rbot).
	> options - An array of strings for the button choices (e.g., ["Yes", "No"]).
	"""
	var popup_container = $CanvasLayer/Window/Popup
	var popup_menu = $CanvasLayer/Window/Popup/PopupMenu
	var prompt_label = $CanvasLayer/Window/Popup/Label

	if not popup_menu or not prompt_label or not popup_container:
		print("idiot")
		return
		
	popup_menu.clear() # just in case
	for i in range(options.size()):
		var option_text = options[i]
		# add_item(text, id) <-- id is what we get from the signal -f
		popup_menu.add_item(option_text, i)

	prompt_label.text = prompt

	var screen_size = get_viewport().get_visible_rect().size
	# waiting a frame to calculate the size
	await get_tree().process_frame
	var popup_size = popup_container.size # use the parent size for positioning
	
	var target_position = Vector2.ZERO
	match pos_rel:
		"center":
			target_position = screen_size / 2 - popup_size / 2
		"rtop":
			target_position = Vector2(screen_size.x - popup_size.x, 0)
		"ltop":
			target_position = Vector2.ZERO # top-left is (0, 0)
		"lbot":
			target_position = Vector2(0, screen_size.y - popup_size.y)
		"rbot":
			target_position = Vector2(screen_size.x - popup_size.x, screen_size.y - popup_size.y)
		_: # else, center
			target_position = screen_size / 2 - popup_size / 2
			
	popup_container.position = target_position
	
	# reveal thyself
	popup_container.popup() 

func _on_popup_id_pressed(id: int):
	"""
	Called when a popup menu option is selected.
	The id corresponds to the index of the option in the array.
	"""
	print(id)
	
	# the PopupMenu hides automatically, but we might want to hide the whole container
	var popup_container = $CanvasLayer/Window/Popup
	if popup_container:
		# popup_container.hide() # test this!!!
		pass

	match id:
		0:
			print("yea")
		1:
			print("nea")
		2:
			print("sdfsdf")

#	- make the item Sprite2D <-- done(??)
#	- make a ui popup <-- done(??)
#	- show the rect and its label <-- ^^^ ([1])
#	- set label text to have placeholder for replace current item with nomral
#	- y/n input listener <-- done(??)
#	- replace inventory <-- VVV magic array bullshit, wip
	
#	- player inventory system and stats <-- huge array?
#	- battle thingy (turn-based)
