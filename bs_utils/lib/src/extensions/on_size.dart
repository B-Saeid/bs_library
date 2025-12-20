import 'dart:ui';

extension SizeUtils on Size {
  bool canContain(Size size) => width >= size.width && height >= size.height;

  Size add(double value) => Size(width + value, height + value);

  Size multiply(double value) => Size(width * value, height * value);

  /// As Size is internally utilizing these operators we could not use them for now.
  /// Maybe there is a way to tell dart which one to use.
  // Size operator +(double value) => Size(width + value, height + value);
  //
  // Size operator -(double value) => Size(width - value, height - value);
  //
  // Size operator *(double value) => Size(width * value, height * value);
  //
  // Size operator /(double value) => Size(width / value, height / value);
}
