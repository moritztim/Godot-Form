## A filter with a blacklist or whitelist of strings
class_name ListFilter extends Resource

enum Match {
	## All elements must be present
	ALL = 1,
	## At least one element must be present
	AT_LEAST_ONE = 0
}
## Match requirements
@export var match: Match
## The blacklist or whitelist
@export var elements: Array[String]

## Returns wether the subject is represented in the list
func is_represented_in(subject: String)-> bool:
	for element in elements:
		if subject.contains(element):
			if !bool(match): ## If any element is present and AT_LEAST_ONE must be, return true
				return true
			## else, keep looking
		elif bool(match): ## If any element is not present but ALL must be, return false
			return false
	## if we get here it never happened that an element was not present and so both ALL and AT_LEAST_ONE are true.
	return true

## Returns the output of elements.size()
func size():
	return elements.size()
