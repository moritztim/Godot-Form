@tool
## Handles form submission and response over the network.
class_name NetworkProtocol extends Protocol

@export_group("Target")
## Target hostname
@export var host := "localhost"
## Target port
## -1 means "use default port"
@export_range(-1, 65536) var port := - 1:
	set(new_val):
		if new_val >= 0:
			new_val = new_val % 65536
		elif new_val < - 1:
			new_val = 0
		port = new_val

## Use authentication for target
@export var use_host_authentication := false
## Username at target
@export var host_username := "":
	set(new_val):
		use_host_authentication = new_val != ""
		host_username = new_val
## Password at target
@export var host_password := ""
## Path to private key file
@export_file var host_keyfile := ""

## Tries to set host_username based on environment var, if not already set
func _init() -> void:
	if OS.has_environment("USERNAME"):
		host_username = OS.get_environment("USERNAME")