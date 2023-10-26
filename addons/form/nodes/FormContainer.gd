@tool
class_name FormContainer extends Container

@export_group("Submission")
@export var submit_button: Submit
@export var protocol:Protocol


func _ready():
	if submit_button != null:
		submit_button.pressed.connect(submit)

func submit():
	protocol.submit(generate_fields_dict())

func generate_fields_dict(subject: Node = self) -> Dictionary:
	var fields := {}
	var labeled_inputs := []
	for child in subject.get_children():
		if child is FormLabel && child.input != null:
			fields[child.text] = child.input
			labeled_inputs.append(child.input)
		elif child.get_child_count() > 0:
			fields.merge(generate_fields_dict(child))
	for child in subject.get_children():
		if is_input(child) && ! labeled_inputs.has(child):
			fields[child.name] = child
	return fields

static func is_input(subject: Node):
	return (
		# subject is input button
		(
			subject is BaseButton
			# meaning a button, but not one that just opens a popup
			&&! subject is MenuButton
		)
		# or subject is input field
		|| subject is LineEdit
		|| subject is TextEdit
		|| subject is ItemList
		|| subject is Slider
		|| subject is SpinBox
		|| subject is GraphEdit
	)
