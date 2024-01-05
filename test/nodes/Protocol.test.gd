class_name ProtocolTest extends ClassTest

func run():
	instance = Protocol.new()
	test_sanitize(
		"No sanitization",
		"Hello World!",
		"Hello World!",
		Protocol.Sanitization.NONE
	)
	test_sanitize(
		"Alphanumeric",
		"H3ll0!",
		"H3ll0",
		Protocol.Sanitization.ALPHANUMERIC
	)
	test_sanitize(
		"Shell Escape",
		"\"Hello World!\\\"",
		"\\\"Hello World\\!\\\\\\\"",
		Protocol.Sanitization.SHELL_ESCAPE
	)
	test_sanitize(
		"Shell Blacklist",
		"\"Hello World!\\\"",
		"Hello World",
		Protocol.Sanitization.SHELL_BLACKLIST
	)
	test_sanitize(
		"Shell Whitelist",
		"Hello World?",
		"Hello World",
		Protocol.Sanitization.SHELL_WHITELIST
	)
	test_sanitize(
		"Custom Blacklist",
		"Hello!",
		"Hell",
		Protocol.Sanitization.NONE,
		Protocol.Sanitization.NONE,
		false,
		"!o"
	)
	test_sanitize(
		"Sanitize Keys",
		{
			"Hello World!": "Hello World!"
		},
		{
			"Hello World": "Hello World"
		},
		Protocol.Sanitization.NONE,
		Protocol.Sanitization.NONE,
		true,
		"!"
	)



func test_sanitize(
	test_name,
	## Any Variant that needs to be sanitized.
	## Dictionaries and Arrays are sanitized recursively.
	## Any other type will be returned as is.
	subject: Variant,
	## Expected value
	expected: Variant,
	## How User Input is sanitized when the protocol deems it necessary.
	sanitization: Protocol.Sanitization,
	## The sanitization method to use.
	sanitization_override:Protocol.Sanitization = sanitization,
	## Whether to sanitize Dictionary keys. Note that this is passed down recursively.
	sanitize_keys := false,
	## Additional characters to remove from user input before sanitization.
	## Example: "@#$%&!"
	blacklist: String = ""
):
	var jail = []
	instance.sanitization = sanitization
	instance.blacklist = blacklist
	var actual = instance.sanitize(subject, jail, sanitization_override, sanitize_keys)
	compare(actual, expected, "sanitize() with " + test_name)
	print("caught:\n", jail)
