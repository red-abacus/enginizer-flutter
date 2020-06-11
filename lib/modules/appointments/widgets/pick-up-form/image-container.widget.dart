import 'dart:io';

import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/generic-model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageContainerWidget extends StatelessWidget {
  File file;
  int index;
  final Function addImage;
  final Function removeImage;
  GenericModel image;
  final double height;

  ImageContainerWidget(this.height, {this.file, this.index, this.addImage, this.removeImage, this.image});

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return _fileContainer();
    } else if (image != null) {
      return _imageContainer();
    }

    return _emptyContainer(context);
  }

  _emptyContainer(BuildContext context) {
    return FlatButton(
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      padding: EdgeInsets.all(0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Container(
        height: this.height,
        width: this.height,
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          border: Border.all(color: red),
          borderRadius: BorderRadius.all(const Radius.circular(10)),
        ),
        child: Center(
          child: Text(
            S.of(context).general_add_image,
            style: TextHelper.customTextStyle(null, red, FontWeight.bold, 14),
          ),
        ),
      ),
      onPressed: () {
        if (addImage != null) {
          addImage(this.index);
        }
      },
    );
  }

  _fileContainer() {
    return FlatButton(
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      padding: EdgeInsets.all(0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Container(
        height: height,
        width: this.height,
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
          border: Border.all(color: red),
          borderRadius: BorderRadius.all(const Radius.circular(10)),
        ),
      ),
      onPressed: () {
        if (addImage != null) {
          addImage(this.index);
        }
      },
    );
  }

  _imageContainer() {
    return Stack(
      children: [
        Container(
          height: height,
          width: this.height,
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(color: red),
            borderRadius: BorderRadius.all(const Radius.circular(10)),
          ),
          child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/icons/camera.svg',
              image: image.name,
              fit: BoxFit.cover),
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () {
              if (this.removeImage != null) {
                this.removeImage(this.image);
              }
            },
            child: Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(right: 10, top: 10),
              child: Container(
                width: 20,
                height: 20,
                child: Icon(Icons.close, color: red),
              ),
            ),
          ),
        )
      ],
    );
  }
}
