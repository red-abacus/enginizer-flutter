import 'package:app/modules/auctions/enum/appointment-status.enum.dart';
import 'package:app/utils/date_utils.dart';

class AppointmentsRequest {
  String searchString;
  DateTime dateTime;
  AppointmentStatusState state;
  int pageSize = 20;
  int currentPage = 0;
  List<String> ids = [];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> propMap = {
      'pageSize': pageSize.toString(),
      'page': currentPage.toString()
    };

    if (searchString != null && searchString.isNotEmpty) {
      propMap['search'] = searchString;
    }

    if (state != null) {
      propMap['status'] = AppointmentStatusStateUtils.status(state);
    }

    if (dateTime != null) {
      propMap['startDate'] = DateUtils.stringFromDate(dateTime, 'dd/MM/yyyy');
      propMap['endDate'] = DateUtils.stringFromDate(dateTime, 'dd/MM/yyyy');
    }

    if (ids.length > 0) {
      propMap['ids'] = ids;
    }

    return propMap;
  }
}