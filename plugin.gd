@tool
extends EditorPlugin

var _types: Array[String]

func _enter_tree():
	add_custom_types([
		["FormContainer", "Container", preload("nodes/FormContainer.gd"), preload("icons/FormContainer.svg")],
		["Submit", "Button", preload("nodes/Submit.gd"), preload("icons/Submit.svg")],
		["ValidatableLineEdit", "LineEdit", preload("nodes/ValidatableLineEdit.gd"), preload("icons/ValidatableLineEdit.svg")],
		["ValidatableTextEdit", "TextEdit", preload("nodes/ValidatableTextEdit.gd"), preload("icons/ValidatableTextEdit.svg")],
		["FormLabel", "Label", preload("nodes/FormLabel.gd"), preload("icons/FormLabel.svg")],
		["Validator", "Resource", preload("nodes/Validator.gd"), preload("icons/Validator.svg")],
		["Boundaries", "Resource", preload("nodes/Boundaries.gd"), preload("icons/Boundaries.svg")],		
		["ListFilter", "Resource", preload("nodes/ListFilter.gd"), preload("icons/ListFilter.svg")],
		["Protocol", "Resource", preload("nodes/Protocol.gd"), preload("icons/Protocol.svg")],
		["ApiProtocol", "Resource", preload("nodes/Protocols/ApiProtocol.gd"), preload("icons/ApiProtocol.svg")],
		["HttpProtocol", "Resource", preload("nodes/Protocols/HttpProtocol.gd"), preload("icons/HttpProtocol.svg")],
		["MailProtocol", "Resource", preload("nodes/Protocols/MailProtocol.gd"), preload("icons/MailProtocol.svg")],
		["SmtpMailProtocol", "Resource", preload("nodes/Protocols/SmtpMailProtocol.gd"), preload("icons/SmtpMailProtocol.svg")],
		["MailsendSmtpMailProtocol", "Resource", preload("nodes/Protocols/MailsendSmtpMailProtocol.gd"), preload("icons/MailsendSmtpMailProtocol.svg")]
	])

func add_custom_types(types: Array):
	for type in types:
		_types.append(type[0])
		add_custom_type(type[0], type[1], type[2], type[3])

func _exit_tree():
	for _type in _types:
		remove_custom_type(_type)
