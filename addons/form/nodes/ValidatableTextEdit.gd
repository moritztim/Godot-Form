class_name ValidatableTextEdit extends TextEdit

@export var validator: Validator

func _init():
	if validator:
		validator.style_valid = get_theme_stylebox("normal")
