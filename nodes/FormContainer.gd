@tool
class_name FormContainer extends Container

@export_group("Submission")
@export var submit_button: Submit
@export var protocol:Protocol


func _ready():
	if submit_button != null:
		submit_button.pressed.connect(submit)

func submit():
	var fields := {}
	for child in get_children():
		if is_input(child):
			fields[child.name] = child.value
	protocol.submit(fields)

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
