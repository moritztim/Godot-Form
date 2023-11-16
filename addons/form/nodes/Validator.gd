@tool
## Validates Input according to rules
class_name Validator extends Resource
## Types that can be validated
## See Variant.Type for possible return values
func get_type() -> int:
	return TYPE_OBJECT

## Validation passed (updated on text change)
var valid := false
## Broken Rules with names and relevant value
var broken_rules := {}

## Validates subject against all rules and returns validity
func validate(subject: Object) -> bool:
	if typeof(subject) != get_type():
		push_error("Subject must be of type ", get_type(), " (see Variant.Type)")
	broken_rules = {}
	return valid
