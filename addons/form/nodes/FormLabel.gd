@tool
class_name FormLabel extends Label


## Input control to label
@export var input: Control:
	set(new_val):
		if FormContainer.is_input(new_val):
			input = new_val
			mode = mode # run setter
			indicate_required()
		else:
			printerr(get_class(),": input must be a input button or input field")
## Input must have a value
@export var input_required := false:
	set(new_val):
		input_required = new_val
		indicate_required()

@export_group("Label Display")

## String to append to label if input_required
@export var required_hint := "*"

enum Mode {
	## Display the text as the label.text
	SEPARATE,
	## Hide the label and overwrite input.placeholder_text or for lack thereof, input.text
	IN_INPUT,
	## Hide the label
	HIDDEN
}
## How to display the label
@export var mode := Mode.SEPARATE:
	set(new_val):
		if new_val == null:
			new_val = Mode.SEPARATE
		mode = new_val
	
		if mode == Mode.SEPARATE:
			visible = true
		else:
			visible = false
		if input != null:
			var input_prop_list = input.get_property_list().map(func(prop): return prop.name)
			for prop in ["placeholder_text", "text"]:
				if prop in input_prop_list:
					if mode == Mode.IN_INPUT:
						input[prop] = text
					else:
						input[prop] = ""
					break

func _enter_tree():
	if input != null && text in [null, ""]:
		text = input.name

## Add or remove the required_hint if input_required
func indicate_required():
	# if * needed but not present
	if required_hint not in ["", null] && input_required && !text.ends_with(required_hint):
		# add
		text += required_hint
		mode = mode # run setter
	# if * present but not needed
	elif text.ends_with(required_hint):
		# remove
		text = text.left(text.length() - required_hint.length())
		mode = mode # run setter
