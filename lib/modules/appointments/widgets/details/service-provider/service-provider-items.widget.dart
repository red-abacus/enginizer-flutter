import 'package:app/generated/l10n.dart';
import 'package:app/modules/appointments/model/provider/service-provider-item.model.dart';
import 'package:app/modules/appointments/providers/service-provider-details.provider.dart';
import 'package:app/modules/authentication/models/provider-schedule-slot.model.dart';
import 'package:app/modules/authentication/models/provider-schedule.model.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/text.helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceProviderItemWidget extends StatefulWidget {
  @override
  ServiceProviderItemWidgetState createState() {
    return ServiceProviderItemWidgetState();
  }
}

class ServiceProviderItemWidgetState extends State<ServiceProviderItemWidget> {
  @override
  Widget build(BuildContext context) {
    ServiceProviderDetailsProvider provider =
        Provider.of<ServiceProviderDetailsProvider>(context);

    List<ServiceProviderItem> items =
        provider.serviceProviderItemsResponse.items;

    return SingleChildScrollView(
      child: Column(
        children: [
          for (ProviderSchedule schedule in provider.providerSchedule)
            _timetableRow(schedule),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return _buildRow(items[index]);
              },
              scrollDirection: Axis.vertical,
              itemCount: items.length,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRow(ServiceProviderItem item) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 6, bottom: 6),
      child: Row(
        children: <Widget>[
          Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
              color: red,
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              item.name,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(
                '- ${item.rate} ${S.of(context).general_currency}',
                style: TextStyle(
                  fontSize: 14,
                  color: gray,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _timetableRow(ProviderSchedule schedule) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 4),
            child: Text(
              schedule.dayOfWeek,
              style: TextHelper.customTextStyle(
                  color: black_text, weight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 10 / 4,
              children: List.generate(
                schedule.slots.length,
                (int index) {
                  return _hourContainer(schedule.slots[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _hourContainer(ProviderScheduleSlot slot) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${slot.startTime} - ${slot.endTime}',
              style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 10, color: black_text),
              textAlign: TextAlign.center)
        ],
      ),
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: red, width: 1),
        borderRadius: new BorderRadius.all(
          const Radius.circular(4.0),
        ),
      ),
    );
  }
}
