## Handles form submission and response over the network using E-Mail.
class_name MailProtocol extends NetworkProtocol

const HTML_SUBSTITUTES := {
	"&": "&amp;", # must be first
	
	"\"": "&quot;",
	"<": "&lt;",
	">": "&gt;",
	"'": "&apos;",
}

@export_group("Body")
enum BodyFormat {
	## HyperText Markup Language Form with disabled inputs
	HTML,
	## {key}: {value}
	PLAIN_TEXT,
	## JavaScript Object Notation
	JSON
}
@export var body_format: BodyFormat = BodyFormat.HTML
## Path to CSS file to use for styling regardless of body_format
@export_file var css := "../../styles/default.css"

@export_group("Metadata")
## Sender name
@export var from_name: String
## Sender address
@export var from_address: String
## Recipient address
@export var to_address: String
## Subject line
@export var subject: String

## Submits form data in an E-Mail to the recipient and returns HTTP status code of the response.
func submit(fields: Dictionary) -> int:
	return super.submit(fields)

## Generates the body for the E-Mail in the body_format.
func generate_body(
	## Output of Form.generate_fields_dict() to populate body
	fields: Dictionary
) -> String:
	var body := ""
	var style := ""
	var suffix := ""
	var format_line := "{key}: {value}\n"

	if body_format == BodyFormat.HTML:
		body = "<html><body><form>"
		if FileAccess.file_exists(css):
			style = "<style>" + FileAccess.get_file_as_string(css) + "</style>"
		format_line = "<label>{key}</label><{container_type} disabled type=\"{type}\" {suffix}"			
		suffix = "</form></body></html>"
	elif body_format == BodyFormat.JSON:
		body = "{"
		format_line = "\"{key}\": {value},"
		suffix = "}"
	
	for field in fields:
		var typed_value = super.get_value(fields[field])
		var value := get_value(fields[field])

		# html specific
		var line_suffix : = "value = \"{value}\"><br>".format({"value": value})
		var container_type := "input"

		if body_format == BodyFormat.JSON:
			if typeof(typed_value) == TYPE_STRING || typeof(typed_value) == TYPE_NIL || typeof(typed_value) == TYPE_OBJECT:
				value = "\"" + value + "\""
			# remove trailing comma
			if field == fields.keys().back():
				format_line = format_line.replace(",", "")
		elif body_format == BodyFormat.HTML:
			# if the value is a boolean and true
			if typeof(typed_value) == TYPE_BOOL && typed_value:
				# the input will need the checked attribute but no value
				line_suffix = "checked><br>"
			elif typeof(typed_value) == TYPE_ARRAY:
				line_suffix = ">"
				for item in typed_value:
					var checked = ""
					if item.selected: # set in Protocol.get_value()
						checked = "checked"
					var text = item.text
					sanitize_for_html(text)
					# [x] item
					line_suffix += "<li><input type=\"checkbox\" disabled {value} />{name}</li>".format({
						"value": checked, "name": text
					})
				container_type = "ul"
				line_suffix += "</ul><br>"
			elif typeof(typed_value) == TYPE_STRING:
				value = sanitize_for_html(value)
		body += format_line.format({
			"key": field, "value": value,
			# html specific
			"type": type_to_string(typeof(typed_value)),
			"suffix": line_suffix,
			"container_type": container_type		
		})
	return body + style + suffix

## Converts a type to a string for use in HTML form.
## TYPE_STRING -> "text"
## TYPE_BOOL -> "checkbox"
## TYPE_INT -> "number"
## TYPE_FLOAT -> "number"
## TYPE_ARRAY -> "select"
## TYPE_NIL -> "text"
static func type_to_string(
	## Output of typeof()
	type: int
) -> String:
	return {
		TYPE_STRING: "text",
		TYPE_BOOL: "checkbox",
		TYPE_INT: "number",
		TYPE_FLOAT: "number",
		TYPE_ARRAY: "select",
		TYPE_NIL: "text"
	}[type]

## Returns the value of a node as a string for use in the E-Mail body.
func get_value(subject: Node) -> Variant:
	var value = super.get_value(subject)
	if subject is ItemList && body_format == BodyFormat.JSON:
			return JSON.stringify(value)
	elif subject is ItemList || subject is GraphEdit:
		return ", ".join(value)
	else:
		return str(value)

## Sanitizes a string for use in HTML.
func sanitize_for_html(subject: String) -> String:
	for char in HTML_SUBSTITUTES.keys():
		subject = subject.replace(char, HTML_SUBSTITUTES[char])
	return subject
