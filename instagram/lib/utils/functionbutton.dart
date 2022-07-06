import 'package:flutter/material.dart';

class FunctionButton extends StatelessWidget {
  final Function()? function;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const FunctionButton({
    Key? key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4),
      // color: Colors.white,
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: borderColor
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(text,style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold
          ),),
          width: 250,
          height: 30,
        ),
      ),
    );
  }
}