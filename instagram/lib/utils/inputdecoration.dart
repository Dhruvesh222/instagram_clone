import 'package:flutter/material.dart';
import 'package:instagram/utils/colors.dart';

const inputDecoration = InputDecoration(
  fillColor: primaryColor,
  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor,width: 1)),
  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: blueColor,width: 1)),
);