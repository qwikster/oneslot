extends Node

var items: String = ""

func add_item(item_name: String):
	items = item_name

func has_item(item_name: String) -> bool:
	return items.contains(item_name)

func clear():
	items = ""
