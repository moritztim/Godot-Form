@tool
## Based on tutorial https://docs.godotengine.org/en/stable/tutorials/networking/http_client_class.html#http-client-class
class_name HttpProtocol extends NetworkProtocol

@export_group("Target")
## Use HTTPS
@export var encrypt := true:
	set(new_val):
		encrypt = new_val
		if port in [-1, 443, 80]:
			if encrypt:
				port = 443
			else:
				port = 80
## Target Path
@export var path := "/"

@export_group("Request")
enum Method {
	GET,
	HEAD,
	POST,
	PUT,
	DELETE,
	OPTIONS,
	TRACE,
	CONNECT,
	PATCH
}
## HTTP Method
@export var method:Method = Method.POST
## HTTP Headers
@export var headers:Dictionary = {}

var http = HTTPClient.new()

## Base URL {protocol}://{host}
var base_url:String:
	get:
		var protocol := "http"
		if encrypt:
			protocol += "s"
		return "/".join([
			(protocol + ":/"),
			":".join([host, port])
		])

signal response_recieved(code:int, headers:Dictionary, body:PackedByteArray)

func _init():
	if port == -1:
		if encrypt:
			port = 443
		else:
			port = 80
	

func submit(fields: Dictionary):
	if OS.has_feature("web"):
		push_error("Error: HttpProtocol does not support web export") # because that would require async code
		return

	var err = 0
	var headers_arr:Array = []
	var response_code = 0
	for key in headers:
		headers_arr.append(key + ": " + headers[key])

	err = http.connect_to_host(host, port)
	if err != OK:
		push_error("Error ", err, " connecting to host ", host, ":", port)
		return
	
	while http.get_status() == HTTPClient.STATUS_CONNECTING || http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		if http.get_status() == HTTPClient.STATUS_CONNECTING:
			print("Connecting...")
		else:
			print("Resolving...")
		OS.delay_msec(100)
	
	if http.get_status() != HTTPClient.STATUS_CONNECTED:
		push_error(http_client_status_to_string(http.get_status()))

	
	err = http.request(int(method), path, headers_arr, JSON.stringify(fields))
	if err != OK:
		push_error("Error ", err, " sending request to '", path, "'")
		return
	
	while http.get_status() == HTTPClient.STATUS_CONNECTING:
		http.poll()
		print("Connecting...")
		OS.delay_msec(100)
	
	while http.get_status() == HTTPClient.STATUS_REQUESTING:
		http.poll()
		print("Requesting...")
		OS.delay_msec(100)
	
	if http.get_status() != HTTPClient.STATUS_BODY && http.get_status() != HTTPClient.STATUS_CONNECTED:
		push_error(http_client_status_to_string(http.get_status()))
		return

	if http.has_response():
		response_code = http.get_response_code()
		print("Response Code: ", response_code)

		var data = PackedByteArray()

		while http.get_status() == HTTPClient.STATUS_BODY:
			http.poll()

			var chunk = http.read_response_body_chunk()
			if chunk.size() == 0:
				OS.delay_usec(1000) # wait for buffers to fill
			else:
				data += chunk
		
		response_recieved.emit(response_code, http.get_response_headers_as_dictionary(), data)
	else:
		print("No response")
	return response_code

func http_client_status_to_string(status:int) -> String:
	var error = "Error "
	if status == HTTPClient.STATUS_CANT_RESOLVE:
		error += "resolving host " + host
	elif status == HTTPClient.STATUS_CANT_CONNECT:
		error += "connecting to host " + host + ":" + str(port)
	elif status == HTTPClient.STATUS_CONNECTION_ERROR:
		error += "in HTTP connection"
	elif status == HTTPClient.STATUS_TLS_HANDSHAKE_ERROR:
		error += "in TLS handshake"
	else:
		error += "Status: " + str(status)
	return error
