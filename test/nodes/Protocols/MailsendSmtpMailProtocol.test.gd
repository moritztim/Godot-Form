class_name MailsendSmtpMailProtocolTest extends ClassTest

func run():
	var instance = MailsendSmtpMailProtocol.new()
	instance.sanitization = MailsendSmtpMailProtocol.Sanitization.SHELL_ESCAPE
	var jail = []
	var actual = instance.sanitize_shell_args([
		MailsendSmtpMailProtocol.SHELL_BLACKLIST
	], jail)
	print("caught:\n", jail)
	compare(
		actual,
		[ "\\\"\\$\\%\\`\\!" ],
		"sanitize shell args with SHELL_ESCAPE"
	)
	instance.sanitization = MailsendSmtpMailProtocol.Sanitization.SHELL_WHITELIST
	actual = instance.sanitize_shell_args([
		MailsendSmtpMailProtocol.SHELL_WHITELIST,
		MailsendSmtpMailProtocol.SHELL_BLACKLIST + "}",
		MailsendSmtpMailProtocol.SHELL_WHITELIST + "}" + MailsendSmtpMailProtocol.SHELL_BLACKLIST
	], jail)
	print("caught:\n", jail)
	compare(
		actual,
		[ MailsendSmtpMailProtocol.SHELL_WHITELIST, "", MailsendSmtpMailProtocol.SHELL_WHITELIST ],
		"sanitize shell args with SHELL_WHITELIST"
	)
	instance.sanitization = MailsendSmtpMailProtocol.Sanitization.SHELL_BLACKLIST
	actual = instance.sanitize_shell_args([
		MailsendSmtpMailProtocol.SHELL_WHITELIST,
		MailsendSmtpMailProtocol.SHELL_BLACKLIST + "}",
		MailsendSmtpMailProtocol.SHELL_WHITELIST + "}" + MailsendSmtpMailProtocol.SHELL_BLACKLIST
	], jail)
	print("caught:\n", jail)
	compare(
		actual,
		[ MailsendSmtpMailProtocol.SHELL_WHITELIST + "}", "}", MailsendSmtpMailProtocol.SHELL_WHITELIST + "}" ],
		"sanitize shell args with SHELL_BLACKLIST"
	)
