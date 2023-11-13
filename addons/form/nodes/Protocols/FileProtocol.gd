@tool
## Handles form submission to a JSON file.
class_name FileProtocol extends Protocol

## Directory to save responses to.
@export_global_dir var target_dir

## File name scheme.
## Available variables:
## - {hash}: Hash of the form data.
## - {id}: Number of existing files in the target directory + 1.
## - {year}: Current year.
## - {month}: Current month.
## - {day}: Current day.
## - {weekday}: Current weekday.
## - {hour}: Current hour.
## - {minute}: Current minute.
## - {second}: Current second.
@export var file_name_scheme := "{id}.json"

## Saves form data to a new file according to the file_name_scheme and returns 200.
func submit(    
	## The output of FormContainer.generate_fields_dict().
	fields: Dictionary
) -> int:
	var submission_time := Time.get_date_dict_from_system()
	submission_time.merge(Time.get_time_dict_from_system())
	if (target_dir == "" || target_dir == null):
		push_error("No target directory specified.")
		return 0

	if DirAccess.dir_exists_absolute(target_dir) == false:
		push_error("Target directory does not exist.")
		return 0
	
	var format_dict = {
		"id": DirAccess.get_files_at(target_dir).size() + 1,
		"hash": fields.hash()
	}
	format_dict.merge(submission_time)
	var file_name := file_name_scheme.format(format_dict)

	if FileAccess.file_exists(target_dir + "/" + file_name):
		push_error("File already exists.")
		return 0
	
	var values = fields.values().map(func(input: Node):
		return get_value(input)
	)
	for key in fields.keys():
		fields[key] = values.pop_front()

	var file := FileAccess.open(target_dir + "/" + file_name, FileAccess.WRITE)
	file.store_string(JSON.stringify(fields))
	file.close()

	return 200
