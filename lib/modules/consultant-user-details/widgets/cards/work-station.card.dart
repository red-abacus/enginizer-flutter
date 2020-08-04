import 'package:app/generated/l10n.dart';
import 'package:app/modules/consultant-user-details/models/work-station.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkStationCard extends StatelessWidget {
  final WorkStation workStation;
  final Function showCamera;

  WorkStationCard(this.workStation, this.showCamera);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: gray_80,
              offset: Offset(1.0, 1.0),
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          child: ClipRRect(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _imageContainer(workStation.id),
                _textContainer(context),
                _statusContainer(context),
              ],
            ),
          ),
        ),
      );
    });
  }

  _imageContainer(int index) {
    return FadeInImage.assetNetwork(
      image: workStation?.workStationPersonnel[0]?.image ?? '',
      placeholder: 'assets/images/defaults/default_profile_icon.png',
      fit: BoxFit.fitHeight,
      height: 24,
      width: 24,
    );
  }

  _textContainer(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 10),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text('${workStation.name}',
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.5)),
                Text(
                    '${S.of(context).user_profile_number_of_active_personnel}: ${workStation.workStationPersonnel?.length}',
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        fontSize: 12.8,
                        height: 1.5)),
                SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _statusContainer(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: () {
          showCamera();
        },
        child: Text(
          S.of(context).appointment_video_button_title.toUpperCase(),
          style: TextHelper.customTextStyle(color: red, weight: FontWeight.bold),
        ),
      ),
    );
  }
}
