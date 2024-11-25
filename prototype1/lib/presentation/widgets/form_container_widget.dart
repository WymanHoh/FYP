import 'package:flutter/material.dart';

class FormContainerWidget extends StatefulWidget {
  final TextEditingController? controller;
  final Key? fieldKey;
  final bool? isPasswordField;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputType? inputType;
  final Color? textColor; // Added: Text color
  final Color? borderColor; // Added: Border color
  final Color? backgroundColor; // Added: Background color

  const FormContainerWidget({
    super.key,
    this.controller,
    this.isPasswordField,
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.inputType,
    this.textColor = Colors.white, // Default: White text color
    this.borderColor = Colors.grey, // Default: Grey border
    this.backgroundColor = const Color.fromARGB(255, 23, 24, 26), // Default: Dark background
  });

  @override
  FormContainerWidgetState createState() => FormContainerWidgetState();
}

class FormContainerWidgetState extends State<FormContainerWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: widget.backgroundColor, // Apply background color
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: widget.borderColor!), // Apply border color
      ),
      child: TextFormField(
        style: TextStyle(color: widget.textColor), // Apply text color
        controller: widget.controller,
        keyboardType: widget.inputType,
        key: widget.fieldKey,
        obscureText: widget.isPasswordField ?? false ? _obscureText : false,
        onSaved: widget.onSaved,
        validator: widget.validator,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: widget.backgroundColor, // Match container color
          hintText: widget.hintText,
          hintStyle: TextStyle(color: widget.textColor?.withOpacity(0.6)), // Faded text color
          suffixIcon: widget.isPasswordField == true
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: _obscureText ? Colors.grey : Colors.blue,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
