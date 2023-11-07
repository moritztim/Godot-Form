# Quick Start
Get a form up and running in 10 steps.
## Installing the plugin
1. Install the plugin ~~from the Asset Library tab in Godot. Or~~ by following the [Installation](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Installation) instructions.
## Creating the structure
2. Add a [`FormContainer`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#FormContainer-container) to your scene.
3. Add a `Container` of your choice as a child of the [`FormContainer`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#FormContainer-container) to hold the form elements.
4. For each form element, add a [`FormLabel`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#formlabel--label) and any input `Control`.
5. Finally, add a [`Submit`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#submit) button.
## Hooking everything up
6. In the inspector of your [`FormContainer`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#FormContainer-container), set the [`Submit Button`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#submit_button-submit) property to your [`Submit`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#submit) button.
7. In the inspector of each element, set the [`input`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#input-control) property to the corresponding `Control` node.
## Configuring the form
8. In the inspector of your [`FormContainer`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#FormContainer-container), choose and set up a [`Protocol`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#protocol-resource).
    Currently supported protocols are:
    - [`HttpProtocol`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#httpprotocol-networkprotocol)
    - [`MailsendSmtPMailProtocol`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#mailsendsmtpmailprotocol-smtpmailprotocol-)
    Of course, you can also implement your own protocol by extending the [`Protocol`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#protocol-resource) class or any of its descendants.
9. In the inspector of each [`FormLabel`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#formlabel--label), set the [`input_required`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#input_required-false) property if needed.
10. In the inspector of each input `Control`, set and configure the [`Validator`](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Code-Reference#validator-resource) property with rules.

> More info in the [Wiki](https://github.com/moritz-t-w/Godot-Form-AL/wiki)