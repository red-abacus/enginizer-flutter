import 'package:enginizer_flutter/modules/authentication/models/user-provider-schedule-slot.model.dart';
import 'package:enginizer_flutter/utils/date_utils.dart';

class UserProviderSchedule {
  int id;
  String dayOfWeek;
  List<UserProviderScheduleSlot> slots;

  UserProviderSchedule({this.id, this.dayOfWeek, this.slots});

  factory UserProviderSchedule.fromJson(Map<String, dynamic> json) {
    if (json['dayOfWeek'] != null) {
      return UserProviderSchedule(
          id: json['id'],
          dayOfWeek: json['dayOfWeek'],
          slots: _mapScheduleSlots(json['scheduleDto']));
    }

    return null;
  }

  static _mapScheduleSlots(List<dynamic> response) {
    List<UserProviderScheduleSlot> items = [];

    if (response != null) {
      response.forEach((item) {
        items.add(UserProviderScheduleSlot.fromJson(item));
      });
    }

    return items;
  }
}
