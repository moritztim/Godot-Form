@tool
## Label for input controls
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
## "Input value must not be empty"
@export var input_required := false:
	set(new_val):
		input_required = new_val
		indicate_required()

## "Input value must be true or non-boolean"
@export var input_must_be_true := true

@export_group("Input Display")

## The style to apply to the input when invalid
@export var invalid_style: StyleBox

## The style to apply to the input when valid
var valid_style: StyleBox:
	get:
		if input && _valid_style == null:
			_valid_style = input.get_stylebox("normal") 
		return _valid_style
## Internal storage for valid_style
var _valid_style

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

## Sets the label text to the input's name if it is empty
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

## Change style based on validity and return validity or default if input is not validatable
func indicate_validity(
	## the default value to return if input is not validatable
	default := true
) -> bool:
	var valid = default
	# no input = not validatable -> valid = default
	if input:
		if (!has_property(input, "text") && input_must_be_true) || input.text == "":
			# input is required but empty or input must be true but is not -> valid = false
			if input_required || (input_must_be_true && has_property(input, "button_pressed") && !input.button_pressed):
				valid = false
			# else: valid = default, but that's already done
		# has text and validator -> valid = validate()
		elif has_property(input, "validator") && input.validator != null:
			valid = input.validator.validate(input.text)
		
		if invalid_style != null:
			var style = invalid_style
			if valid:
				style = valid_style
			input.add_theme_stylebox_override("normal", style)
		else:
			var msg = "No invalid_style set"
			if !valid:
				push_warning(msg)
			else:
				print(msg)
	return valid

## Return validity of "Subject has property_name and it is not a method"
func has_property(subject:Object, property_name) -> bool:
	return property_name in subject && !subject.has_method(property_name)
