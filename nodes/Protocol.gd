class_name Protocol extends Resource

## Submits form data and returns HTTP status code of the response
func submit(fields: Dictionary) -> int:
	push_error("not implemented")
	return -1

func get_value(subject: Node):
	if subject is BaseButton:
		return subject.button_pressed
	elif subject is LineEdit || subject is TextEdit:
		return subject.text
	elif subject is ItemList:
		var items: Array[Dictionary] = []
		for i in range(subject.get_item_count()):
			items.append({
				"selected": subject.is_selected(i),
				"text": subject.get_item_text(i),
				"icon": subject.get_item_icon(i),
				"metadata": subject.get_item_metadata(i)
			})
		return items
	elif subject is Slider || subject is SpinBox:
		return subject.value
	elif subject is GraphEdit:
		return subject.get_connection_list()
	else:
		push_error("Unknown input type: " + str(subject))
		return null
