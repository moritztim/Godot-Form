class_name MailsendSmtpMailProtocolTest extends ClassTest

func run():
	var instance = MailsendSmtpMailProtocol.new()
	instance.sanitization = MailsendSmtpMailProtocol.Sanitization.SHELL_ESCAPE
	compare(
		instance.sanitize_shell_args([
			MailsendSmtpMailProtocol.SHELL_BLACKLIST
		]),
		[ "\\\"\\$\\%\\`\\!" ],
		"sanitize shell args with SHELL_ESCAPE"
	)
	instance.sanitization = MailsendSmtpMailProtocol.Sanitization.SHELL_WHITELIST
	compare(
		instance.sanitize_shell_args([
			MailsendSmtpMailProtocol.SHELL_WHITELIST,
			MailsendSmtpMailProtocol.SHELL_BLACKLIST + "}",
			MailsendSmtpMailProtocol.SHELL_WHITELIST + "}" + MailsendSmtpMailProtocol.SHELL_BLACKLIST
		]),
		[ MailsendSmtpMailProtocol.SHELL_WHITELIST, "", MailsendSmtpMailProtocol.SHELL_WHITELIST ],
		"sanitize shell args with SHELL_WHITELIST"
	)
	instance.sanitization = MailsendSmtpMailProtocol.Sanitization.SHELL_BLACKLIST
	compare(
		instance.sanitize_shell_args([
			MailsendSmtpMailProtocol.SHELL_WHITELIST,
			MailsendSmtpMailProtocol.SHELL_BLACKLIST + "}",
			MailsendSmtpMailProtocol.SHELL_WHITELIST + "}" + MailsendSmtpMailProtocol.SHELL_BLACKLIST
		]),
		[ MailsendSmtpMailProtocol.SHELL_WHITELIST + "}", "}", MailsendSmtpMailProtocol.SHELL_WHITELIST + "}" ],
		"sanitize shell args with SHELL_BLACKLIST"
	)
