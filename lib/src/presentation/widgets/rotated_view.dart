import 'package:camera_camera/src/presentation/widgets/rotated_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class RotatedView extends StatelessWidget {
  const RotatedView({super.key, required this.child});

  final Widget child;

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
      return child;
    }
    return RotatedBox(
      quarterTurns: quarterTurns,
      child: child,
    );
  }
}