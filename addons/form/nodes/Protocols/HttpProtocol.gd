@tool
## Handles form submission and response over the network using HyperText Transfer Protocol
## Web export is not supported.
## Based on tutorial https://docs.godotengine.org/en/stable/tutorials/networking/http_client_class.html#http-client-class
class_name HttpProtocol extends NetworkProtocol

@export_group("Target")
## Use HTTPS
@export var encrypt := true:
	set(new_val):
		encrypt = new_val
		if port in [- 1, 443, 80]:
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
@export var method := Method.POST
## HTTP Headers
@export var headers := {}

## HTTP Client
var http := HTTPClient.new()

## {protocol}://{host}
var base_url: String:
	get:
		var protocol := "http"
		if encrypt:
			protocol += "s"
		return "/".join([
			(protocol + ":/"),
			":".join([host, port])
		])

signal response_recieved(
	## HTTP Status Code
	code: int,
	headers: Dictionary,
	body: PackedByteArray
)

## Sets the port to 443 if encrypt is true, otherwise 80, if it is set to -1.
func _init():
	if port == - 1:
		if encrypt:
			port = 443
		else:
			port = 80

## Submits form data and returns HTTP status code of the response.
## Web export is not supported.
func submit(fields: Dictionary):
	if OS.has_feature("web"):
		push_error("Error: HttpProtocol does not support web export") # because that would require async code
		return

	var err = 0
	var headers_arr: Array = []
	var response_code = 0
	for key in headers:
		headers_arr.append(key + ": " + headers[key])

	err = http.connect_to_host(host, port)
	if err != OK:
		push_error("Error ", err, " connecting to host ", host, ":", port)
		return

	while http.get_status() == HTTPClient.STATUS_CONNECTING||http.get_status() == HTTPClient.STATUS_RESOLVING:
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

	if http.get_status() != HTTPClient.STATUS_BODY&&http.get_status() != HTTPClient.STATUS_CONNECTED:
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

## Returns a string representation of the HTTPClient.STATUS_. or "Status: {status}" if the status is not one of the following:
## 2. Error resolving host {host}
## 4. Error connecting to host {host}:{port}
## 8. Error in HTTP connection
## 9. Error in TLS handshake
func http_client_status_to_string(
	## Status returned by HTTPClient.get_status()
	status: int
) -> String:
	var error := "Error {0}"
	var msg := ""
	match status:
		HTTPClient.STATUS_CANT_RESOLVE:
			msg = "resolving host " + host
		HTTPClient.STATUS_CANT_CONNECT:
			msg = "connecting to host " + host + ":" + str(port)
		HTTPClient.STATUS_CONNECTION_ERROR:
			msg = "in HTTP connection"
		HTTPClient.STATUS_TLS_HANDSHAKE_ERROR:
			msg = "in TLS handshake"
		_:
			msg = "Status: " + str(status)
	return error.format([msg])
