@tool
## Manages form submission and is intended to contain the form elements and contains the is_input() method.
class_name FormContainer extends Container

@export_group("Submission")
## Calls the submit() function when pressed.
@export var submit_button: Submit:
	set(new_val):
		if new_val != null:
			new_val.pressed.connect(submit)
		else:
			submit_button.pressed.disconnect(submit)
		submit_button = new_val
## Handles the submission of the form.
@export var protocol:Protocol

## Submits the form data to the protocol if the data is valid.
func submit():
	var fields := generate_fields_dict(true)
	var valid := true
	for field in fields.values():
		if !field["label"] != null && !field["label"].indicate_validity():
			valid = false
	if !valid:
		return
	protocol.submit(fields)

## Generates a dictionary of the form data.
func generate_fields_dict(
	## if include_labels:
	## 	return { { "label": ..., "input": ... }, ... }
	## else:
	## 	return { input, ... }
	include_labels: bool = false,
	## The node to generate the dictionary from.
	## This is mainly used for recursion.
	subject: Node = self
) -> Dictionary:
	var fields := {}
	var labeled_inputs := []

	for child in subject.get_children():
		# If the child is a label with an associated input, add it to the dictionary.
		if child is FormLabel && child.input != null:
			if include_labels:
				fields[child.text] = {
					"label": child,
					"input": child.input,
				}
			else:
				fields[child.text] = child.input
			labeled_inputs.append(child.input)
		# Else if the child serves as a container, recursively add its children.
		elif child.get_child_count() > 0:
			# Add the child's children to the dictionary as they are returned from the recursive call.
			fields.merge(generate_fields_dict(include_labels, child))
	
	# Before we checked only inputs that have labels, so this adds the remaining ones.
	for child in subject.get_children():
		# If it's an input and it hasn't been added yet, add it.
		if is_input(child) && ! labeled_inputs.has(child):
			if include_labels:
				fields[child.name] = {
					"label": null,
					"input": child,
				}
			else:
				fields[child.name] = child
	return fields

## Returns whether the given node is an input.
## Inputs are:
## - buttons except MenuButton
## - LineEdit
## - TextEdit
## - ItemList
## - Slider
## - SpinBox
## - GraphEdit
static func is_input(subject: Node) -> bool:
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
