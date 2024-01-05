## Handles form submission and response over the network using mailsend.
## Mailsend must be installed.
class_name MailsendSmtpMailProtocol extends SmtpMailProtocol

@export var mailsend_executable_path = "mailsend-go"

@export_group("Mailsend Arguments")
## Print debug messages
@export var debug: bool = false
## Verify Certificate in connection
@export var verifyCert: bool = false
## Write log messages to this file
@export_global_file var log: String = ""

# Calls mailsend with the given body and parameters based on the properties and returns the status code.
func handle_smtp(
	## E-mail body
	body: String
) -> int:
	var output := []
	var args := [
		"-smtp", host, "-port", port,
		"auth",
			"-user", username,
			"-pass", password,

		"-sub", subject,
		"-fname", from_name,
		"-f", from_address,
		"-t", to_address,

		"body",	"-msg", body
	]

	if debug:
		args.append("-debug")
	if verifyCert:
		args.append("-verifyCert")
	if log != "":
		args.append_array(["-log", log])
	
	sanitize_shell_args(args)
	print("Running ", " ", mailsend_executable_path, " \"", "\" \"".join(args), "\"")
	var code = OS.execute(mailsend_executable_path, args, output, true)
	for line in output[0].split("\n"):
		print("mailsend: ", line)
	return code

## Sanitize subject for use as shell command args
func sanitize_shell_args(
	## Shell Command Args (passed by reference)
	subject: Array[String],
	## Stores every instance of every character that was caught by the sanitization in order of appearance (passed by reference)
	jail: Array[String] = []
):
	var i := 0
	subject.map(func (arg):
		var sanitized = sanitize(arg, jail[i], sanitization, true)
		if sanitization != Sanitization.SHELL_ESCAPE && sanitization != Sanitization.SHELL_BLACKLIST:
			sanitized = sanitize(sanitized, jail[i], Sanitization.SHELL_ESCAPE, true)
		i++
		return sanitized
	)