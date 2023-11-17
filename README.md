<h1 align="center">
	<img src="icon.svg" alt="Icon"> <br>
	Godot Form Plugin
</h1>

## Example
### In the Editor
This is how a form might look in the editor: <br>
![Form in the editor](addons/form/readme%20images/Editor.png)
### In Action
This is how the form might look in the game: <br>
![Form in action](addons/form/readme%20images/Game_400.png)

## Requirements
- Godot 4.1 or higher
> Godot 4.0 might work, but is not tested.
- For [`MailsendSmtPMailProtocol`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#mailsendsmtpmailprotocol-smtpmailprotocol-): [mailsend-go](https://github.com/muquit/mailsend-go) or [mailsend](https://github.com/muquit/mailsend)

## Quick Start
Get a form up and running in 11 steps.
### Installing the plugin
1. Install the plugin from the Asset Library tab in Godot or from the [Asset Library Page](https://godotengine.org/asset-library/asset/9752) or by following the [Installation](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Installation)  instructions. When the following prompt comes up, select only the "addons" folder: <br>
	![Download only the addons folder](addons/form/readme%20images/Download.png)
2. Enable the plugin in the Project Settings: <br>
	![Enable the plugin](addons/form/readme%20images/Enable.png)
### Creating the structure
3. Add a [`Form`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#Form) to your scene.
4. Add a `Container` of your choice as a child of the [`Form`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#Form) to hold the form elements.
5. For each form element, add a [`FormLabel`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#formlabel--label) and any input `Control`.
6. Finally, add a [`Submit`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#submit) button.
### Hooking everything up
7. In the inspector of your [`Form`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#Form), set the [`Submit Button`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#submit_button-submit) property to your [`Submit`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#submit) button.
8. In the inspector of each element, set the [`input`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#input-control) property to the corresponding `Control` node.
### Configuring the form
9. In the inspector of your [`Form`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#Form), choose and set up a [`Protocol`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#protocol-resource).
		Currently supported protocols are:
		- [`HttpProtocol`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#httpprotocol-networkprotocol)
		- [`MailsendSmtPMailProtocol`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#mailsendsmtpmailprotocol-smtpmailprotocol-)
		- [`FileProtocol`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#fileprotocol-protocol)
> Of course, you can also implement your own protocol by extending the [`Protocol`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#protocol-resource) class or any of its descendants.
10. In the inspector of each [`FormLabel`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#formlabel--label), set the [`input_required`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#input_required-false) property if needed.
11. In the inspector of each input `Control`, set and configure the [`Validator`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#validator-resource) property with rules.

> More info in the [Wiki](https://github.com/moritz-t-w/Godot-Form-AL/wiki)