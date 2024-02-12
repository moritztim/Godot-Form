@tool
## Label for input controls
class_name FormLabel extends Label

## Input control to label
@export var input: Control:
	set(new_val):
		if new_val == null||Form.is_input(new_val):
			if input != null:
				input.gui_input.disconnect(_on_gui_input)
			input = new_val
			mode = mode # run setter
			indicate_required()
			if validate_on_input&&input != null:
				input.gui_input.connect(_on_gui_input)
		else:
			printerr(get_class(), ": input must be a input button or input field")
## "Input value must not be empty"
@export var input_required := false:
	set(new_val):
		input_required = new_val
		indicate_required()

## Indicate validity when the input node recieves a GUI input
@export var validate_on_input := true

@export_group("Input Display")

## The style to apply to the input when invalid
@export var invalid_style: StyleBox

## The style to apply to the input when valid
var valid_style: StyleBox:
	get:
		if input&&_valid_style == null:
			_valid_style = input.get_theme_stylebox("normal")
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
			var found := false
			for prop in ["placeholder_text", "text"]:
				if has_property(input, prop):
					if mode == Mode.IN_INPUT:
						input[prop] = text
					elif input[prop] == text:
						input[prop] = ""
					found = true
					break
			if !found&&mode == Mode.IN_INPUT:
				push_error("Input ", input.get_instance_id(), " has no placeholder_text or text property")
				mode = Mode.SEPARATE
				visible = true

## Sets the label text to the input's name if it is empty and runs necessary setters
func _enter_tree():
	if input != null&&text in [null, ""]:
		text = input.name
	if !visibility_changed.is_connected(update_display_mode):
		visibility_changed.connect(update_display_mode)

func _ready():
	indicate_required()

## Update label display mode based on visibility
## If the label is visible and the mode is either Mode.IN_INPUT or Mode.HIDDEN, the mode is set to Mode.SEPARATE.
## If the label is not visible and the mode is Mode.SEPARATE, the mode is set to Mode.HIDDEN.
## Else the mode setter is run (mode = mode).
func update_display_mode():
	if visible&&(mode == Mode.IN_INPUT||mode == Mode.HIDDEN):
		mode = Mode.SEPARATE
	elif !visible&&mode == Mode.SEPARATE:
		mode = Mode.HIDDEN
	else:
		# run setter
		mode = mode

## Add or remove the required_hint if input_required
func indicate_required():
	if !is_node_ready():
		return
	# if * needed but not present
	if input_required:
		if required_hint not in ["", null]&&!text.ends_with(required_hint):
			# add
			text += required_hint
	# if * present but not needed
	elif text.ends_with(required_hint):
		# remove
		text = text.left(text.length() - required_hint.length())
	mode = mode # run setter

## Change style based on validity and return validity or default if input is not validatable
func indicate_validity(
	## the default value to return if input is not validatable
	default:=true
) -> bool:
	var valid = default
	# no input = not validatable -> valid = default
	if input:
		var broken_rules := {}
		var value = Protocol.new().get_value(input)
		var input_has_not_null_validator = has_property(input, "validator")&&input.validator != null

		if input_required&&(value == null||((value is String||value is StringName)&&value == "")):
			# input is required but empty -> valid = false
				broken_rules["required"] = true
				valid = false
			# else: valid = default, but that's already done
		# has text and validator -> valid = validate()
		elif input_has_not_null_validator:
			valid = input.validator.validate(input.text)
			if !valid:
				broken_rules = input.validator.broken_rules
		else: # Has a text value or doesn't have to be true, has no validation rules. -> valid = true
			valid = true

		if !valid:
			print("Input ", input.get_instance_id(), " breaks the following rule(s):")
			print(broken_rules)

		if invalid_style != null:
			valid_style # run getter
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
func has_property(subject: Object, property_name: StringName) -> bool:
	return property_name in subject&&!subject.has_method(property_name)

## Indicate validity on GUI input if event is relevant and validate_on_input
func _on_gui_input(event: InputEvent):
		if validate_on_input&&!(event is InputEventMouseMotion)&&Form.is_input(input)&&(
			event is InputEventMouseButton&&event.button_index == MOUSE_BUTTON_LEFT&&!event.pressed&&( # left click release
				input is BaseButton
				||input is Slider
				||input is SpinBox
				||input is GraphEdit
			)
			||event is InputEventKey
		):
			indicate_validity.call_deferred() # ensure value is updated before validation
