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
	if body_format == BodyFormat.HTML:
		body = "<html><body>"
		suffix = "</body></html>"
	elif body_format == BodyFormat.JSON:
		body = "{"
		suffix = "}"
	for field in fields:
		var format_line := "{key}: {value}"
		if body_format == BodyFormat.HTML:
			format_line = "<p><b> {key} </b>: {value} </p>"
		elif body_format == BodyFormat.PLAIN_TEXT:
			format_line += "\n"
		body += format_line.format({"key": field, "value": fields[field]})
	return body + suffix
