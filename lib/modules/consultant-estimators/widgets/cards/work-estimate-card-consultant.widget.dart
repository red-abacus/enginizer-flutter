import 'package:app/modules/consultant-estimators/enums/work-estimate-status.enum.dart';
import 'package:app/modules/consultant-estimators/models/work-estimate.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WorkEstimateCardConsultant extends StatelessWidget {
  final WorkEstimate workEstimate;
  final Function selectWorkEstimate;

  WorkEstimateCardConsultant({this.workEstimate, this.selectWorkEstimate});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1.0, 1.0),
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          child: InkWell(
            splashColor: Theme.of(context).primaryColor,
            onTap: () => this.selectWorkEstimate(this.workEstimate),
            child: ClipRRect(
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _imageContainer(),
                    _textContainer(),
                    _statusContainer(context),
                  ]),
            ),
          ),
        ),
      );
    });
  }

  _imageContainer() {
    Color color =
        workEstimate.getStatus() == WorkEstimateStatus.PENDING ? red : yellow;

    return Container(
      width: 100,
      height: 100,
      padding: EdgeInsets.all(10),
      color: color,
      child: SvgPicture.asset(
        // TODO - need to check image here
        'assets/images/statuses/in_bid.svg',
        semanticsLabel: 'Appointment Status Image',
      ),
    );
  }

  _textContainer() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        height: 100,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text('${workEstimate.appointment?.name}',
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.5)),
                Text('${workEstimate.createdDate}',
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
    Color color =
        workEstimate.getStatus() == WorkEstimateStatus.PENDING ? red : yellow;

    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Text(
        workEstimate.statusTitle(context).toUpperCase(),
        textAlign: TextAlign.right,
        style: TextHelper.customTextStyle(null, color, FontWeight.bold, 14),
      ),
    );
  }
}
