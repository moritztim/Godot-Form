class_name MailProtocol extends Protocol

@export_group("Body")
enum BodyFormat {
	HTML,
	PLAIN_TEXT,
	JSON
}
@export var body_format: BodyFormat = BodyFormat.HTML
@export_file var css := "../../styles/default.css"

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
		var line_suffix : = "value = \"{value}\"><br>".format({"value": value})
		var container_type := "input"
		if body_format == BodyFormat.JSON:
			if typeof(typed_value) == TYPE_STRING:
				value = "\"" + value + "\""
			if field == fields.keys().back():
				format_line.replace(",", "")
		elif body_format == BodyFormat.HTML:
			if typeof(typed_value) == TYPE_BOOL && typed_value:
				line_suffix = "checked><br>"
			elif typeof(typed_value) == TYPE_ARRAY:
				line_suffix = ">"
				for item in typed_value:
					var checked = ""
					if item.selected:
						checked = "checked"
					line_suffix += "<li><input type=\"checkbox\" disabled {value} />{name}</li>".format({
						"value": checked, "name": item.text
					})
				container_type = "ul"
				line_suffix += "</ul><br>"
		body += format_line.format({
			"key": field, "value": value,
			"type": type_to_string(typeof(typed_value)),
			"suffix": line_suffix,
			"container_type": container_type		
		})
	return body + style + suffix

static func type_to_string(type: int) -> String:
	return {
		TYPE_STRING: "text",
		TYPE_BOOL: "checkbox",
		TYPE_INT: "number",
		TYPE_FLOAT: "number",
		TYPE_ARRAY: "select",
		TYPE_NIL: "text"
	}[type]

func get_value(subject: Node) -> String:
	var value = super.get_value(subject)
	var string_value := ""
	var suffix := ""
	var format_line := "{item}"

	if subject is ItemList:
		if body_format == BodyFormat.JSON:
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
