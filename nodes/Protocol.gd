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
		return subject.get_selected_items()
	elif subject is Slider || subject is SpinBox:
		subject.value
	elif subject is GraphEdit:
		return subject.get_connection_list()
	else:
		push_error("Unknown input type: " + str(subject))
		return null
