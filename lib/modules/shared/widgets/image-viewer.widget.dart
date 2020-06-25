import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageViewer extends StatelessWidget {
  final File file;
  final String name;

  ImageViewer({this.file, this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Container(
        child: Image.file(file),
      ),
    );
  }
}
