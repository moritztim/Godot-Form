## Handles form submission and response.
class_name Protocol extends Resource

## Submits form data and returns HTTP status code of the response.
func submit(
	## The output of FormContainer.generate_fields_dict().
	fields: Dictionary
) -> int:
	push_error("not implemented")
	return -1

## Finds the value of the given Node based on its type.
## Throws an error if the type is unknown.
## BaseButton -> button_pressed: bool
## LineEdit | TextEdit -> text: String
## Slider | SpinBox -> value: float
## GraphEdit -> get_connection_list(): Array[Dictionary]
## ItemList -> items: Array[{
##	selected = is_selected(): bool,
##	text: get_item_text(): String,
##	icon: get_item_icon(): Texture,
##	metadata: get_item_metadata(): Variant
## }]
func get_value(subject: Node) -> Variant:
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
