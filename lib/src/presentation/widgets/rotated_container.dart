import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class RotatedContainer extends StatelessWidget {
  const RotatedContainer({
    super.key,
    this.padding,
    this.alignment,
    required this.child,
  });

  final EdgeInsets? padding;
  final Alignment? alignment;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _buildContainer(context, null);
    }
    final orientation = NativeDeviceOrientationReader.orientation(context);
    return _buildContainer(context, turns[orientation]);
  }

  Widget _buildContainer(BuildContext context, int? quarterTurns) {
    if (quarterTurns == null) {
      return Container(
        alignment: alignment,
        padding: padding,
        child: child,
      );
    }
    return RotatedBox(
      quarterTurns: quarterTurns,
      child: Container(
        alignment: alignment,
        padding: padding,
        child: RotatedBox(
          quarterTurns: -quarterTurns,
          child: child,
        ),
      ),
    );
  }
}

Map<NativeDeviceOrientation, int> turns = {
  NativeDeviceOrientation.portraitUp: 0,
  NativeDeviceOrientation.landscapeRight: 1,
  NativeDeviceOrientation.portraitDown: 2,
  NativeDeviceOrientation.landscapeLeft: 3,
};