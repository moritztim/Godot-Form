class_name MailsendSmtpMailProtocolTest extends ClassTest

func run():
	instance = MailsendSmtpMailProtocol.new()
	instance.sanitization = MailsendSmtpMailProtocol.Sanitization.SHELL_ESCAPE
	var jail = []
	var actual = instance.sanitize_shell_args([
		MailsendSmtpMailProtocol.SHELL_BLACKLIST
	], jail)
	compare(
		actual,
		[ "\\\"\\$\\%\\`\\!" ],
		"sanitize shell args with SHELL_ESCAPE"
	)
	print("caught:\n", jail)
	instance.sanitization = MailsendSmtpMailProtocol.Sanitization.SHELL_WHITELIST
	jail = []
	actual = instance.sanitize_shell_args([
		MailsendSmtpMailProtocol.SHELL_WHITELIST,
		MailsendSmtpMailProtocol.SHELL_BLACKLIST + "}",
		MailsendSmtpMailProtocol.SHELL_WHITELIST + "}" + MailsendSmtpMailProtocol.SHELL_BLACKLIST
	], jail)
	compare(
		actual,
		[ MailsendSmtpMailProtocol.SHELL_WHITELIST, "", MailsendSmtpMailProtocol.SHELL_WHITELIST ],
		"sanitize shell args with SHELL_WHITELIST"
	)
	print("caught:\n", jail)
	instance.sanitization = MailsendSmtpMailProtocol.Sanitization.SHELL_BLACKLIST
	jail = []
	actual = instance.sanitize_shell_args([
		MailsendSmtpMailProtocol.SHELL_WHITELIST,
		MailsendSmtpMailProtocol.SHELL_BLACKLIST + "}",
		MailsendSmtpMailProtocol.SHELL_WHITELIST + "}" + MailsendSmtpMailProtocol.SHELL_BLACKLIST
	], jail)
	compare(
		actual,
		[
			MailsendSmtpMailProtocol.SHELL_WHITELIST,
			"}",
			MailsendSmtpMailProtocol.SHELL_WHITELIST + "}"
		],
		"sanitize shell args with SHELL_BLACKLIST"
	)
	print("caught:\n", jail)
