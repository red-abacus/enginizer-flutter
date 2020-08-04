import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  Function imageSelected;

  ImagePickerWidget({this.imageSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50, bottom: 50),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            child: Text("Open Camera"),
            onPressed: () {
              _getImage(context, ImageSource.camera);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).primaryTextTheme.button.color,
          ),
          RaisedButton(
            child: Text("Open Gallery"),
            onPressed: () {
              _getImage(context, ImageSource.gallery);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).primaryTextTheme.button.color,
          ),
        ],
      ),
    );
  }

  _getImage(BuildContext context, ImageSource imageSource) async {
    var image = await ImagePicker.pickImage(
        source: imageSource, maxWidth: 1024, maxHeight: 1024);

    if (image != null) {
      cropImage(context, image);
    }
  }

  Future<File> cropImage(BuildContext context, image) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop image',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    if (croppedFile != null) if (imageSelected != null) {
      imageSelected(croppedFile);
    } else if (imageSelected != null) {
      imageSelected(image);
    }

    Navigator.pop(context);
  }
}
