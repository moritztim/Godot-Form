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
		if field["label"] != null && !field["label"].indicate_validity():
			valid = false
	if !valid:
		return
	protocol.submit(generate_fields_dict())

## Generates a dictionary of the form data.
## Keys are generated from the node names.
## If a key with the same name already exists, the instance id is joined with an underscore to the key.
## Example of a key with instance id: "Input_29460792527"
func generate_fields_dict(
	## if include_labels:
	## 	return { { "label": ..., "input": ... }, ... }
	## else:
	## 	return { input, ... }
	include_labels: bool = false,
	## The node to generate the dictionary from.
	## This is mainly used for recursion.
	subject: Node = self,
	## The dictionary to add the fields to.
	## This is mainly used for recursion.
	fields := {}
) -> Dictionary:
	var labeled_inputs := []

	for child in subject.get_children():
		# If the child is a label with an associated input, add it to the dictionary.
		if child is FormLabel && child.input != null:
			var key := generate_unique_key(child, fields)
			if include_labels:
				fields[key] = {
					"label": child,
					"input": child.input,
				}
			else:
				fields[key] = child.input
			labeled_inputs.append(child.input)
		# Else if the child serves as a container, recursively add its children.
		elif child.get_child_count() > 0:
			# Add the child's children to the dictionary as they are returned from the recursive call.
			fields.merge(generate_fields_dict(include_labels, child, fields))
	
	# Before we checked only inputs that have labels, so this adds the remaining ones.
	for child in subject.get_children():
		# If it's an input and it hasn't been added yet, add it.
		if FormContainer.is_input(child) && ! labeled_inputs.has(child):
			var key := generate_unique_key(child, fields)
			if include_labels:
				fields[key] = {
					"label": null,
					"input": child,
				}
			else:
				fields[key] = child
	return fields

## Generates a unique key for the subject to be used in the object.
func generate_unique_key(subject: Node, object: Dictionary) -> StringName:
	var key := subject.name
	if subject is FormLabel:
		key = subject.text
	if key in object.keys(): # if there is already an input with this name, add the instance id to the key
		var id = subject.get_instance_id()
		key += &"_{0}".format([id]) # ensure StringName
		if key in object.keys():
			printerr("Duplicate input instance id: " + str(id) + ". Overwriting.")
	return key

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
