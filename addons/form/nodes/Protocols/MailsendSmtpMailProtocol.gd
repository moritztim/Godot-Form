class_name MailsendSmtpMailProtocol extends SmtpMailProtocol

@export var mailsend_executable_path = "mailsend-go"

@export_group("Mailsend Arguments")
## Print debug messages
@export var debug: bool = false
## Verify Certificate in connection
@export var verifyCert: bool = false
## Write log messages to this file
@export_global_file var log: String = ""

func handle_smtp(body: String) -> int:
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
	
	args = args.map(func (arg):
		if typeof(arg) == TYPE_STRING:
			return arg.replace("\"", "\\\"")
		else:
			return arg
	)
	print("Running ", " ", mailsend_executable_path, " \"", "\" \"".join(args), "\"")
	var code = OS.execute(mailsend_executable_path, args, output, true)
	for line in output[0].split("\n"):
		print("mailsend: ", line)
	return code
