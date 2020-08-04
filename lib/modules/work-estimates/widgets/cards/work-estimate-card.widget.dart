import 'package:app/generated/l10n.dart';
import 'package:app/modules/work-estimate-form/enums/work-estimate-status.enum.dart';
import 'package:app/modules/work-estimates/enums/work-estimate-payment-status.enum.dart';
import 'package:app/modules/work-estimates/models/work-estimate.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WorkEstimateCard extends StatelessWidget {
  final WorkEstimate workEstimate;
  final Function selectWorkEstimate;

  WorkEstimateCard({this.workEstimate, this.selectWorkEstimate});

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
            child: Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _textContainer(context),
                  _statusContainer(context),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  _textContainer(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  children: [
                    Text('${workEstimate.car?.registrationNumber ?? ''}',
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            height: 1.5)),
                    Expanded(
                      child: Text(' - ${workEstimate.appointment?.name}',
                          style: TextStyle(
                              color: darkGray,
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              height: 1.5)),
                    )
                  ],
                ),
                Text('${workEstimate.createdDate}',
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        fontSize: 12.8,
                        height: 1.5)),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text('${S.of(context).estimator_totalProducts}:',
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.normal,
                            fontSize: 12.8,
                            height: 1.5)),
                    SizedBox(width: 5),
                    Text(
                        '${workEstimate.totalProducts.toStringAsFixed(1)} ${S.of(context).general_currency}',
                        style: TextStyle(
                            color: red,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            height: 1.5)),
                  ],
                ),
                Row(
                  children: [
                    Text('${S.of(context).estimator_totalServices}:',
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.normal,
                            fontSize: 12.8,
                            height: 1.5)),
                    SizedBox(width: 5),
                    Text(
                        '${workEstimate.totalServices.toStringAsFixed(1)} ${S.of(context).general_currency}',
                        style: TextStyle(
                            color: red,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            height: 1.5)),
                  ],
                ),
                Row(
                  children: [
                    Text('${S.of(context).estimator_total}:',
                        style: TextStyle(
                            color: Colors.black87,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.normal,
                            fontSize: 12.8,
                            height: 1.5)),
                    SizedBox(width: 5),
                    Text(
                        '${workEstimate.totalCost.toStringAsFixed(1)} ${S.of(context).general_currency}',
                        style: TextStyle(
                            color: red,
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            height: 1.5)),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _statusContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Row(
        children: [
          Text(
            WorkEstimateStatusUtils.title(context, workEstimate.status),
            textAlign: TextAlign.right,
            style: TextHelper.customTextStyle(
                color: WorkEstimateStatusUtils.color(workEstimate.status),
                weight: FontWeight.bold,
                size: 14),
          ),
          SizedBox(
            width: 2,
          ),
          Text(
            '(${WorkEstimatePaymentStatusUtils.title(context, workEstimate.paymentStatus)})',
            textAlign: TextAlign.right,
            style: TextHelper.customTextStyle(
                color: WorkEstimateStatusUtils.color(workEstimate.status),
                weight: FontWeight.bold,
                size: 14),
          )
        ],
      ),
    );
  }
}
