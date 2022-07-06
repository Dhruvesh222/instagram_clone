import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async{
  final ImagePicker _imagepicker = ImagePicker();

  final XFile? file = await _imagepicker.pickImage(source: source);
  if(file!=null){
    return await file.readAsBytes();
  }
  print("file not selected");

}

snackbar(String message,BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message) )
  );
}