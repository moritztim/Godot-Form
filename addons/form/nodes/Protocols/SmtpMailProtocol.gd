@tool
## Handles form submission and response over the network using Simple Mail Transfer Protocol (SMTP).
class_name SmtpMailProtocol extends MailProtocol

enum SecurityType {
	NONE = 0,
	SSL = 465,
	TLS = 587
}
## Security Type
## Adjusts the port if it is 0, 465 or 587.
@export var security_type: SecurityType = SecurityType.SSL:
	set(new_val):
		security_type = new_val
		if port in SecurityType.values():
			port = new_val # TODO: this does not work and I have no idea why

@export_group("Authentication")
## Authenticate with the mail server
@export var use_authentication := true
## Username at the mail server
@export var username: String
## Password at the mail server
@export var password: String

## Sets the port based on the security type if it is -1.
func _init() -> void:
	if port == -1:
		port = security_type

## Returns handle_smtp(generate_body(fields)).
func submit(
	## Output of Form.generate_fields_dict() to populate body
	fields:Dictionary
) -> int:
	return handle_smtp(generate_body(fields))


## Handles the SMTP request and returns the status code.
func handle_smtp(
	##E-Mail body
	body: String
) -> int:
	push_error("not implemented")
	return -1
