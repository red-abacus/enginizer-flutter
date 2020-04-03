import 'package:app/modules/consultant-appointments/providers/pick-up-car-form-consultant.provider.dart';
import 'package:app/modules/consultant-appointments/widgets/pick-up-form/image-container.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageSelectionWidget extends StatelessWidget {
  int _imagesPerRow = 3;
  double _imageHeight = 0;

  final double _minimWidth = 100;

  Function addImage;

  PickUpCarFormConsultantProvider _provider;

  ImageSelectionWidget({this.addImage});

  @override
  Widget build(BuildContext context) {
    double totalSize = MediaQuery.of(context).size.width - 20.0;

    if (totalSize / 3 < _minimWidth) {
      _imagesPerRow = 2;
      _imageHeight = totalSize / 2;
    } else {
      _imageHeight = totalSize / 3;
    }

    _provider = Provider.of<PickUpCarFormConsultantProvider>(context);

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          for (int i = 0; i < _provider.files.length / _imagesPerRow; i++)
            _imagesRow(i),
        ],
      ),
    );
  }

  _imagesRow(int index) {
    return Row(
      children: <Widget>[
        for (int i = index; i < index + _imagesPerRow; i++)
          Expanded(
            flex: 1,
            child:
                Container(height: _imageHeight, child: _getImageContainer(i)),
          )
      ],
    );
  }

  _getImageContainer(int index) {
    return index < _provider.files.length
        ? ImageContainerWidget(
            file: _provider.files[index], index: index, addImage: addImage)
        : Container();
  }
}
