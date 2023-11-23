## Handles form submission and response.
class_name Protocol extends Resource

## Characters other than escape characters that can do bad things within a quoted shell command argument.
const SHELL_BLACKLIST = "\"$%`!"

## Characters that are probably fine inside a quoted shell command argument.
const SHELL_WHITELIST = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_,.-+=@#/()'"

@export_group("Security")
enum Sanitization {
	## No sanitization is performed.
	## Only do this if you are holding your user at gunpoint to ensure they don't do anything malicious.
	NONE,
	## Metacharacters that work inside quotes are escaped.
	## This might not be completely safe.
	SHELL_ESCAPE,
	## Metacharacters that work inside quotes are removed.
	SHELL_BLACKLIST,
	## Only definetly safe characters are kept.
	## See SHELL_WHITELIST
	SHELL_WHITELIST,
	## Only Alphanumeric characters are kept.
	ALPHANUMERIC
}
## How User Input is sanitized when the protocol deems it necessary.
@export var sanitization: Sanitization = Sanitization.SHELL_WHITELIST

## Additional characters to remove from user input before sanitization.
## Example: "@#$%&!"
@export var blacklist: String = ""

## Submits form data and returns HTTP status code of the response.
func submit(
	## The output of Form.generate_fields_dict().
	fields: Dictionary
) -> int:
	push_error("not implemented")
	return -1

## Finds the value of the given Node based on its type.
## Throws an error if the type is unknown.
## BaseButton -> button_pressed: bool
## LineEdit | TextEdit -> text: String
## Slider | SpinBox -> value: float
## GraphEdit -> get_connection_list(): Array[Dictionary]
## ItemList -> items: Array[{
##	selected = is_selected(): bool,
##	text = get_item_text(): String,
##	icon = get_item_icon(): Texture,
##	metadata = get_item_metadata(): Variant
## }]
func get_value(subject: Node) -> Variant:
	if subject is BaseButton:
		return subject.button_pressed
	elif subject is LineEdit || subject is TextEdit:
		return subject.text
	elif subject is ItemList:
		var items: Array[Dictionary] = []
		for i in range(subject.get_item_count()):
			items.append({
				"selected": subject.is_selected(i),
				"text": subject.get_item_text(i),
				"icon": subject.get_item_icon(i),
				"metadata": subject.get_item_metadata(i)
			})
		return items
	elif subject is Slider || subject is SpinBox:
		return subject.value
	elif subject is GraphEdit:
		return subject.get_connection_list()
	else:
		push_error("Unknown input type: " + str(subject))
		return null

## Sanitizes subject according to the selected sanitization method.
func sanitize(
	## Any Variant that needs to be sanitized.
	## Dictionaries and Arrays are sanitized recursively.
	## Any other type will be returned as is.
	subject: Variant,
	## Stores every instance of every character that was caught by the sanitization in order of appearance.
	jail := [],
	## The sanitization method to use.
	sanitization_override := sanitization,
	## Whether to sanitize Dictionary keys. Note that this is passed down recursively.
	sanitize_keys := false
) -> Variant:
	var sanitized := subject

	
	match typeof(subject):
		TYPE_DICTIONARY:
			sanitized = {}
			for key in subject.keys():
				var sub_subject = subject[key]
				if sanitize_keys:
					key = sanitize(key, jail)
				sanitized[key] = sanitize(sub_subject, jail, sanitization_override, sanitize_keys)
		TYPE_ARRAY:
			sanitized = []
			for item in subject:
				sanitized.append(sanitize(item, jail, sanitization_override, sanitize_keys))
		TYPE_STRING: # This is where the magic happens
			sanitized = ""
			# Blacklist
			if blacklist not in [null]:
				var original_subject = subject
				subject = ""
				for char in original_subject:
					if char not in blacklist:
						subject += char
					else:
						jail.append(char)
			
			# Sanitization
			var escape_char = "\\"
			if OS.get_name() == "Windows":
				escape_char = "^" # Windows is not like the other kids
			match sanitization_override:
				Sanitization.NONE:
					sanitized = subject
				Sanitization.SHELL_ESCAPE:
					for char in subject:
						if char in [SHELL_BLACKLIST, escape_char]: # if it's a naughty char
							sanitized += escape_char # add escape char
							jail.append(char)
						sanitized += char # add char
				Sanitization.SHELL_BLACKLIST:
					for char in subject:
						if !( char in [SHELL_BLACKLIST, escape_char] ): # if allowed
							sanitized += char # add char
						else:
							jail.append(char)
				Sanitization.SHELL_WHITELIST:
					for char in subject:
						if char in SHELL_WHITELIST:
							sanitized += char # add char
						else:
							jail.append(char) # lock char away
				Sanitization.ALPHANUMERIC:
					var regex := RegEx.new()
					regex.compile("[^a-zA-Z0-9]") # non alphanumeric
					var result := regex.search_all(subject)
					var matches := []
					for match in result:
						matches.append(match.get_string())
					for char in subject:
						if char in matches:
							sanitized += char
							jail.append(char)
	var size = jail.size()
	if size > 0:
		print("Protocol.sanitze() found ", size, " illegal characters: in user input.")
	return sanitized
