// ignore: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular(
      { this.width = double.infinity, required this.height})
      : this.shapeBorder=const RoundedRectangleBorder();
  const ShimmerWidget.circular(
      {  required this.width, required this.height,
      this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.white70,

      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(shape: shapeBorder,
        color: Colors.white70,)
      ),
    );
  }
}
