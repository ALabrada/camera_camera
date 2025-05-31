import 'package:camera_camera/src/presentation/controller/camera_camera_controller.dart';
import 'package:camera_camera/src/presentation/controller/camera_camera_status.dart';
import 'package:camera_camera/src/presentation/widgets/resize_preview.dart';
import 'package:camera_camera/src/presentation/widgets/rotated_container.dart';
import 'package:camera_camera/src/shared/entities/camera_mode.dart';
import 'package:flutter/material.dart';

import '../../../camera_camera.dart';

class CameraCameraPreview extends StatefulWidget {
  final void Function(String value)? onFile;
  final Widget Function(BuildContext context, Widget child)? onPreview;
  final CameraCameraController controller;
  final bool enableZoom;
  final Widget? triggerIcon;
  CameraCameraPreview({
    Key? key,
    this.onFile,
    this.onPreview,
    required this.controller,
    required this.enableZoom,
    required this.triggerIcon,
  }) : super(key: key);

  @override
  _CameraCameraPreviewState createState() => _CameraCameraPreviewState();
}

class _CameraCameraPreviewState extends State<CameraCameraPreview> {
  @override
  void initState() {
    widget.controller.init();
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onPreview = widget.onPreview ?? (_, v) => v;

    return ValueListenableBuilder<CameraCameraStatus>(
      valueListenable: widget.controller.statusNotifier,
      builder: (_, status, __) => status.when(
          success: (camera) => GestureDetector(
                onScaleUpdate: (details) {
                  widget.controller.setZoomLevel(details.scale);
                },
                child: Stack(
                  children: [
                    Center(
                      child: RotatedView(
                        child: ResizePreview(
                          size: widget.controller.previewSize!,
                          child: onPreview(context, widget.controller.buildPreview()),
                        ),
                      ),
                    ),
                    if (camera.zoom != null && widget.enableZoom)
                      RotatedContainer(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(bottom: 116),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.black.withOpacity(0.6),
                          child: IconButton(
                            icon: Center(
                              child: Text(
                                "${camera.zoom?.toStringAsFixed(1)}x",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                            onPressed: () {
                              widget.controller.zoomChange();
                            },
                          ),
                        ),
                      ),
                    if (widget.controller.flashModes.length > 1)
                      RotatedContainer(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.only(bottom: 32, left: 64),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.black.withOpacity(0.6),
                          child: IconButton(
                            onPressed: () {
                              widget.controller.changeFlashMode();
                            },
                            icon: Icon(
                              camera.flashModeIcon,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    RotatedContainer(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 32),
                      child: InkWell(
                        onTap: () {
                          widget.controller.takePhoto();
                        },
                        child: widget.triggerIcon ?? CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          failure: (message, _) => Container(
                color: Colors.black,
                child: Text(message),
              ),
          orElse: () => Container(
                color: Colors.black,
              )),
    );
  }
}
