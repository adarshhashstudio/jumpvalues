import 'package:flutter/material.dart';
import 'package:jumpvalues/widgets/common_widgets.dart';
import 'package:nb_utils/nb_utils.dart';

extension intExt on String {
  Widget iconImage({double? size, Color? color, BoxFit? fit}) => Image.asset(
        this,
        height: size ?? 24,
        width: size ?? 24,
        fit: fit ?? BoxFit.cover,
        color: color ?? black,
        errorBuilder: (context, error, stackTrace) => placeHolderWidget(
            height: size ?? 24, width: size ?? 24, fit: fit ?? BoxFit.cover),
      );
}
