import 'package:enginizer_flutter/modules/appointments/model/service-provider.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarDetailsWidget extends StatefulWidget {
  ServiceProvider serviceProvider;

  CarDetailsWidget(this.serviceProvider);

  @override
  CarDetailsWidgetState createState() => CarDetailsWidgetState();
}

class CarDetailsWidgetState extends State<CarDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FractionallySizedBox(
          heightFactor: 0.4,
          child: Image.network(
            '${widget.serviceProvider.image}',
            fit: BoxFit.fill,
          ),
        )
      ],
    );
  }
}