class_name VtableLineEdit extends LineEdit

@export var validator: Validator

func _init():
	if validator:
		validator.style_valid = get_theme_stylebox("normal")
