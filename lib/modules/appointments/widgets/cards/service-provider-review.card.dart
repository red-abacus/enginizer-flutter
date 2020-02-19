import 'package:enginizer_flutter/modules/appointments/model/provider/service-provider-client-review.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceProviderReviewCard extends StatelessWidget {
  final ServiceProviderClientReview review;

  ServiceProviderReviewCard({this.review});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: 200,
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 10),
        child: Material(
          elevation: 1,
          color: Colors.white,
          borderRadius: new BorderRadius.circular(5.0),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: <Widget>[
              InkWell(
                splashColor: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
                onTap: () => {},
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
