@tool
class_name SmtpMailProtocol extends MailProtocol

@export var host: String
enum SecurityType {
	NONE = 0,
	SSL = 465,
	TLS = 587
}
@export var securityType: SecurityType = SecurityType.SSL:
	set(new_val):
		securityType = new_val
		if port in SecurityType.values():
			port = new_val # TODO: this does not work and I have no idea why
@export var port := 465

@export_group("Authentication")
@export var useAuthentication := true
@export var username: String
@export var password: String


func submit(fields:Dictionary) -> int:
	return handle_smtp(generate_body(fields))

func handle_smtp(body: String) -> int:
	push_error("not implemented")
	return -1
