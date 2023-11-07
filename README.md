# Quick Start
Get a form up and running in 10 steps.
## Installing the plugin
1. Install the plugin ~~from the Asset Library tab in Godot. Or~~ by following the [Installation](https://github.com/moritz-t-w/Godot-Form-AL/wiki/Installation) instructions.
## Creating the structure
2. Add a `FormContainer` to your scene.
3. Add a `Container` of your choice as a child of the `FormContainer` to hold the form elements.
4. For each form element, add a `FormLabel` and any input `Control`.
5. Finally, add a `Submit` button.
## Hooking everything up
6. In the inspector of your `FormContainer`, set the `Submit Button` property to your `Submit` button.
7. In the inspector of each element, set the `Input` property to the corresponding `Control` node.
## Configuring the form
8. In the inspector of your `FormContainer`, choose and set up a `Protocol`.
    Currently supported protocols are:
    - `HttpProtocol`
    - `MailsendSmtPMailProtocol`
    Of course, you can also implement your own protocol by extending the `Protocol` class or any of its descendants.
9. In the inspector of each `FormLabel`, set the `Input Required` property if needed.
10. In the inspector of each input `Control`, set and configure the `Validator` property with rules.

> More info in the [Wiki](https://github.com/moritz-t-w/Godot-Form-AL/wiki)