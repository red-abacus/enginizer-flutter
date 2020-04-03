import 'dart:io';

import 'package:app/generated/l10n.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageContainerWidget extends StatelessWidget {
  File file;
  int index;
  Function addImage;

  ImageContainerWidget({this.file, this.index, this.addImage});

  @override
  Widget build(BuildContext context) {
    return file == null ? _emptyContainer(context) : _imageContainer();
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
        addImage(this.index);
      },
    );
  }

  _imageContainer() {
    return FlatButton(
      hoverColor: Colors.transparent,
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      padding: EdgeInsets.all(0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
          border: Border.all(color: red),
          borderRadius: BorderRadius.all(const Radius.circular(10)),
        ),
      ),
      onPressed: () {
        addImage(this.index);
      },
    );
  }
}
