import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color red8004c = fromHex('#4ca72e3b');

  static Color gray700 = fromHex('#666666');

  static Color gray90014 = fromHex('#14021927');

  static Color gray90026 = fromHex('#26021927');

  static Color gray500 = fromHex('#aaaaaa');

  static Color gray90005 = fromHex('#05021927');

  static Color blueGray100 = fromHex('#d9d9d9');

  static Color blueGray400 = fromHex('#888888');

  static Color gray900 = fromHex('#021927');

  static Color black9000f = fromHex('#0f000000');

  static Color red400 = fromHex('#d74f5d');

  static Color gray300 = fromHex('#dddddd');

  static Color gray100 = fromHex('#f5f5f5');

  static Color gray9000c = fromHex('#0c021927');

  static Color pink8004c = fromHex('#4caa3d49');

  static Color gray9000a = fromHex('#0a021927');

  static Color pink80026 = fromHex('#26aa3d49');

  static Color whiteA700 = fromHex('#ffffff');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
