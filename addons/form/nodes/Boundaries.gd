@tool
## An upper and lower bound for an integer value
class_name Boundaries extends Resource

## Lower bound
@export var min: int:
	set(new_val):
		if new_val > 0:
			min = new_val
		else:
			min = 0
		if min > max:
			max = min
## Upper bound
@export var max: int:
	set(new_val):
		if new_val > 0:
			max = new_val
		else:
			max = 0
		if max < min:
			min = max

## Determines if the subject is within the boundaries
func has(subject: int) -> bool:
	return (max == 0||subject <= max)&&(min == 0||subject >= min)
