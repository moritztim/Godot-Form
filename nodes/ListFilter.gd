class_name ListFilter extends Resource

enum Match { ALL = 1, AT_LEAST_ONE = 0}
@export var match: Match
@export var elements: Array[String]

func is_represented_in(subject: String)-> bool:
	for element in elements:
		if subject.contains(element):
			if !bool(match):
				return true
		else:
			if bool(match):
				return false
	return true

func size():
	elements.size()