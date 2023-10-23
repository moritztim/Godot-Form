class_name MailProtocol extends Protocol

@export_group("Body")
enum BodyFormat {
	HTML,
	PLAIN_TEXT,
	JSON
}
@export var body_format: BodyFormat = BodyFormat.HTML

@export_group("Metadata")
@export var from_name: String
@export var from_address: String
@export var to_address: String
@export var subject: String

func submit(fields: Dictionary) -> int:
	return super.submit(fields)

## Generates an HTML string from a dictionary of fields
func generate_body(fields: Dictionary) -> String:
	var body := ""
	var suffix := ""
	var format_line := "{key}: {value}\n"

	if body_format == BodyFormat.HTML:
		body = "<html><body>"
		format_line = "<p><b> {key} </b>: {value} </p>"
		suffix = "</body></html>"
	elif body_format == BodyFormat.JSON:
		body = "{"
		format_line = "\"{key}\": {value},"
		suffix = "}"
	
	for field in fields:
		var value = get_value(fields[field])
		if body_format == BodyFormat.JSON && typeof(super.get_value(fields[field])) == typeof(""):
			value = "\"" + value + "\""
		body += format_line.format({"key": field, "value": value})
	return body + suffix

func get_value(subject: Node) -> String:
	var value = super.get_value(subject)
	var string_value := ""
	var suffix := ""
	var format_line := "{item}"

	if subject is ItemList:
		if body_format == BodyFormat.HTML:
			string_value = "<ul>"
			format_line = "<li> {item} </li>"
			suffix = "</ul>"
		elif body_format == BodyFormat.JSON:
			string_value = "["
			format_line = "\"{item}\","
			suffix = "]"
		for item in value:
			string_value += format_line.format({"item": item})
		return string_value + suffix
	elif subject is GraphEdit:
		return ", ".join(value)
	else:
		return str(value)
