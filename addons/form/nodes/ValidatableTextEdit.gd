## TextEdit with a validator.
class_name ValidatableTextEdit extends TextEdit

@export var validator: Validator

## Assigns the style from the validator if it exists.
func _init():
	if validator:
		validator.style_valid = get_theme_stylebox("normal")
