import 'dart:io';

import 'package:app/modules/appointments/model/generic-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'image-container.widget.dart';

class ImageSelectionWidget extends StatelessWidget {
  int _imagesPerRow = 3;
  double _imageHeight = 0;

  final double _minimWidth = 100;
  final List<File> files;
  final List<GenericModel> images;

  final Function addImage;
  final Function removeImage;

  ImageSelectionWidget({this.addImage, this.removeImage, this.files, this.images});

  @override
  Widget build(BuildContext context) {
    double totalSize = MediaQuery.of(context).size.width - 20.0;

    if (totalSize / 3 < _minimWidth) {
      _imagesPerRow = 2;
      _imageHeight = totalSize / 2;
    } else {
      _imageHeight = totalSize / 3;
    }

    int total = images != null ? images.length : 0;
    total += files.length;

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          for (int i = 0; i < total / _imagesPerRow; i++) _imagesRow(i),
        ],
      ),
    );
  }

  _imagesRow(int index) {
    return Row(
      children: <Widget>[
        for (int i = index * _imagesPerRow; i < index * _imagesPerRow + 3; i++)
          Expanded(
            flex: 1,
            child:
                Container(height: _imageHeight, child: _getImageContainer(i)),
          )
      ],
    );
  }

  _getImageContainer(int index) {
    int imagesCount = this.images != null ? this.images.length : 0;

    if (index < imagesCount) {
      return ImageContainerWidget(_imageHeight,
          image: this.images[index], index: index, removeImage: removeImage);
    } else if (index < imagesCount + this.files.length) {
      return ImageContainerWidget(_imageHeight,
          file: this.files[index - imagesCount],
          index: index,
          addImage: addImage);
    }

    return Container();
  }
}
