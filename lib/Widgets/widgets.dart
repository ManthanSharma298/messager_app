import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

InputDecoration textFieldFiller(String hintGiven) {
  return InputDecoration(
    hintText: hintGiven,
    hintStyle: const TextStyle(
      color: Colors.white38,
    ),
    // enabledBorder: const OutlineInputBorder(
    //   borderSide: BorderSide(color: Colors.blue),
    // ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white70),
    ),
  );
}

TextStyle textStyleFunc() {
  return const TextStyle(
    color: Colors.white70,
    fontSize: 16,
  );
}

TextStyle textStyleBlackFunc() {
  return const TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}

TextStyle bottomText() {
  return const TextStyle(
    color: Colors.white70,
    fontSize: 16,
    decoration: TextDecoration.underline,
  );
}
