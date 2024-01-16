## A filter with a blacklist or whitelist of strings
class_name ListFilter extends Resource

enum Match {
	## All elements must be present
	ALL = 1,
	## At least one element must be present
	AT_LEAST_ONE = 0
}
## Match requirement
@export var match: Match
## The blacklist or whitelist
@export var elements: Array[String]

## Returns wether the subject is represented in the list
func is_represented_in(subject: String) -> bool:
	for element in elements:
		if subject.contains(element):
			if !bool(match ): # If any element is present and AT_LEAST_ONE must be, return true
				return true
			## else, keep looking
		elif bool(match ): # If any element is not present but ALL must be, return false
			return false
	# If we get here, either every element is present and ALL must be, or no element is present and AT_LEAST_ONE must be
	return bool(match )

## Returns the output of elements.size()
func size() -> int:
	return elements.size()
