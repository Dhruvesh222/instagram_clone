import 'package:flutter/material.dart';
import 'package:instagram/utils/inputdecoration.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController texteditingcontroller;
  final bool ispass;
  final String hinttext;
  final TextInputType textInputType;

  const TextFieldInput({Key? key, required this.texteditingcontroller, this.ispass = false,required this.hinttext,required this.textInputType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputborder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context)
    );
    return TextField(
      controller: texteditingcontroller,
      decoration: InputDecoration(
        hintText: hinttext,
        border: inputborder,
        focusedBorder: inputborder,
        enabledBorder: inputborder,
        filled: true,
        contentPadding: EdgeInsets.all(8),
      ),
      keyboardType: textInputType,
      obscureText: ispass,
    );
  }
}