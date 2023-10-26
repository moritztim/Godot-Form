@tool
class_name Validator extends Resource

const REGEX_LIB = [
	"^[a-zA-Z]+$",
	"^[0-9]+$",
	"^[a-zA-Z0-9]+$",
	"^(?!(?:(?:\\x22?\\x5C[\\x00-\\x7E]\\x22?)|(?:\\x22?[^\\x5C\\x22]\\x22?)){255,})(?!(?:(?:\\x22?\\x5C[\\x00-\\x7E]\\x22?)|(?:\\x22?[^\\x5C\\x22]\\x22?)){65,}@)(?:(?:[\\x21\\x23-\\x27\\x2A\\x2B\\x2D\\x2F-\\x39\\x3D\\x3F\\x5E-\\x7E]+)|(?:\\x22(?:[\\x01-\\x08\\x0B\\x0C\\x0E-\\x1F\\x21\\x23-\\x5B\\x5D-\\x7F]|(?:\\x5C[\\x00-\\x7F]))*\\x22))(?:\\.(?:(?:[\\x21\\x23-\\x27\\x2A\\x2B\\x2D\\x2F-\\x39\\x3D\\x3F\\x5E-\\x7E]+)|(?:\\x22(?:[\\x01-\\x08\\x0B\\x0C\\x0E-\\x1F\\x21\\x23-\\x5B\\x5D-\\x7F]|(?:\\x5C[\\x00-\\x7F]))*\\x22)))*@(?:(?:(?!.*[^.]{64,})(?:(?:(?:xn--)?[a-z0-9]+(?:-[a-z0-9]+)*\\.){1,126}){1,}(?:(?:[a-z][a-z0-9]*)|(?:(?:xn--)[a-z0-9]+))(?:-[a-z0-9]+)*)|(?:\\[(?:(?:IPv6:(?:(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){7})|(?:(?!(?:.*[a-f0-9][:\\]]){7,})(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,5})?::(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,5})?)))|(?:(?:IPv6:(?:(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){5}:)|(?:(?!(?:.*[a-f0-9]:){5,})(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,3})?::(?:[a-f0-9]{1,4}(?::[a-f0-9]{1,4}){0,3}:)?)))?(?:(?:25[0-5])|(?:2[0-4][0-9])|(?:1[0-9]{2})|(?:[1-9]?[0-9]))(?:\\.(?:(?:25[0-5])|(?:2[0-4][0-9])|(?:1[0-9]{2})|(?:[1-9]?[0-9]))){3}))\\]))$",
	# source: emailregex.com
	"^[\\+]?[(]?[0-9]{3}[)]?[-\\s\\.]?[0-9]{3}[-\\s\\.]?[0-9]{4,6}$"
	# source: ihateregex.io/expr/phone
]


@export_group("Rules")

@export_subgroup("Simple Rules")
## Input must have a value
@export var required := false:
	set(new_val):
		if new_val:
			if min_length < 1:
				_prev_min_length = min_length
				min_length = 1
			else:
				min_length = _prev_min_length
		required = new_val
var _prev_min_length := 0
## Minimum number of characters
@export var min_length: int:
	set(new_val):
		if new_val < 0:
			new_val = 0
		if new_val == 0 && required:
			required = false
		min_length = new_val
## Minimum and Maximum number of matches for \w+ allowed
@export var word_range: Boundaries
## List of allowed strings
@export var whitelist: ListFilter
## List of prohibited strings
@export var blacklist: ListFilter

@export_subgroup("Regular Expression")
## Predefined attern to match against
enum PredefinedRegEx {NONE = -1,
	ALPHABETICAL, NUMERICAL, ALPHANUMERICAL, EMAIL_ADDRESS, PHONE_NUMBER
}
@export var predefined: PredefinedRegEx = -1
enum Behaviour {
	## Input must match both the predefined and the custom regex (if both are set)
	MUST_MATCH_BOTH = 0,
	## Input can match either the predefined or the custom regex (if at least one is set)
	CAN_MATCH_EITHER = 1
}
@export var behaviour: Behaviour

## Custom Pattern to match against
@export var custom := ".*"
## Normalise the case before matching
@export var normalise = false
## Don't allow any more than one match
@export var require_single_match: bool


## Validation passed (updated on text change)
var valid := false
var broken_rules := {}
var user_regex: RegEx

func _init() -> void:
	user_regex = RegEx.new()
	user_regex.compile(custom)

func _on_text_changed(new_text: String) -> void:
	valid = validate(new_text)

func validate(subject: String) -> bool:
	var _regex := RegEx.new()


	##-- min_length --##
	var length = subject.length()
	if length < min_length:
		broken_rules["min_length"] = str(length)
		return false


	##-- filter_list --##
	if (
		blacklist != null	&& blacklist.size() > 0
		&& blacklist.is_represented_in(subject)
	):
		broken_rules["filter_list"] = "blacklist"
		return false

	if (
		whitelist != null	&& whitelist.size() > 0
		&& !whitelist.is_represented_in(subject)
	):
		broken_rules["filter_list"] = "whitelist"
		return false


	##-- word_range --##
	if word_range != null && (word_range.min != 0 || word_range.max != 0):
		_regex.compile("\\w+") # word
		var matches = _regex.search_all(subject)
		if matches == null:
			if word_range.min:
				broken_rules["word_range"] = "min"
				return false
			matches = [] # size() = 0
		var count = matches.size()
		if count > word_range.max:
			broken_rules["word_range"] = "max"
			return false

	##-- predefined_regex --##	
	var predefined_regex_result := false

	if predefined != PredefinedRegEx.NONE:
		_regex.compile(REGEX_LIB[predefined])
		if _regex.search(subject) != null:
			predefined_regex_result = true
			if behaviour == Behaviour.CAN_MATCH_EITHER:
				return true
		elif behaviour == Behaviour.MUST_MATCH_BOTH:
			broken_rules["predefined"] = str(behaviour)
			return false
	else:
		predefined_regex_result = true
	
	##-- user_regex --##
	if user_regex not in ["", null, ".*"]:
		if normalise:
			subject = subject.to_lower()

		if require_single_match:
			var matches = user_regex.search_all(subject)
			if matches != null && matches.size() == 1 && matches[0].get_string() == subject.strip_edges():
				return true
			return predefined_regex_result || bool(behaviour)
		elif user_regex.search(subject) != null:
				return true
	return true
