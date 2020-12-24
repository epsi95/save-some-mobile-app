import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:blobs/blobs.dart';

class Blobs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double blobSize = width / 1;
    double blobOpacity = 0.2;
    return Stack(
      children: [
        Positioned(
          right: 0 - (blobSize / 2),
          top: 0 - (blobSize / 2),
          child: Blob.animatedRandom(
            duration: Duration(seconds: 3),
            edgesCount: 8,
            minGrowth: 6,
            loop: true,
            size: blobSize,
            styles:
                BlobStyles(color: Color(0xFFEE0072).withOpacity(blobOpacity)),
          ),
        ),
        Positioned(
          left: 0 - (blobSize / 3),
          top: (height / 2) - (blobSize / 1.5),
          child: Blob.animatedRandom(
            duration: Duration(seconds: 3),
            edgesCount: 8,
            minGrowth: 6,
            loop: true,
            size: blobSize,
            styles:
                BlobStyles(color: Color(0xFF6200EE).withOpacity(blobOpacity)),
          ),
        ),
        Positioned(
          left: 0 - (blobSize / 2),
          bottom: 0 - (blobSize / 2),
          child: Blob.animatedRandom(
            duration: Duration(seconds: 3),
            edgesCount: 8,
            minGrowth: 6,
            loop: true,
            size: blobSize,
            styles:
                BlobStyles(color: Color(0xFFEE0072).withOpacity(blobOpacity)),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Container(
            height: height,
            width: width,
            decoration:
                BoxDecoration(color: Color(0xFFA697FF).withOpacity(0.5)),
          ),
        )
      ],
    );
  }
}
